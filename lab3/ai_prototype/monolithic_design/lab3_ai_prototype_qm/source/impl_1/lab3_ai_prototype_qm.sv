// Top-level keypad + dual-7seg controller for iCE40 UP5K
// - All state synchronous
// - Uses idiomatic SystemVerilog (logic, always_ff, enumerations)
// - Default oscillator frequency assumed ~20_000_000 Hz; adjust OSC_FREQ_HZ if different.

`timescale 1ns/1ps

// ------------------------------
// Clock divider: generates two synchronous single-cycle pulses:
//   - scan_tick (e.g., ~150 Hz) used to step keypad column and sample rows
//   - disp_tick (e.g., ~1 kHz) used to multiplex display (toggles active digit)
// ------------------------------
module clk_divider #(
    parameter int OSC_FREQ_HZ = 20_000_000,
    parameter int SCAN_HZ    = 150,    // keypad column step rate (100..200 recommended)
    parameter int DISP_HZ    = 1000    // display multiplex toggle rate (so each digit ~DISP_HZ/2)
) (
    input  logic clk,
    input  logic rst_n,        // active-low asynchronous reset (synchronized inside)
    output logic scan_tick,    // single-cycle pulse at SCAN_HZ
    output logic disp_tick     // single-cycle pulse at DISP_HZ
);
    // Compute counters (floor)
    localparam int SCAN_COUNT = (OSC_FREQ_HZ / SCAN_HZ);
    localparam int DISP_COUNT = (OSC_FREQ_HZ / DISP_HZ);

    // Counters
    logic [$clog2(SCAN_COUNT+1)-1:0] scan_cnt;
    logic [$clog2(DISP_COUNT+1)-1:0] disp_cnt;

    // Synchronous reset style: use rst_n as async input but synchronous reset to state machine.
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            scan_cnt <= 0;
            scan_tick <= 1'b0;
            disp_cnt <= 0;
            disp_tick <= 1'b0;
        end else begin
            // scan counter
            if (scan_cnt >= SCAN_COUNT-1) begin
                scan_cnt <= 0;
                scan_tick <= 1'b1;
            end else begin
                scan_cnt <= scan_cnt + 1;
                scan_tick <= 1'b0;
            end
            // display counter
            if (disp_cnt >= DISP_COUNT-1) begin
                disp_cnt <= 0;
                disp_tick <= 1'b1;
            end else begin
                disp_cnt <= disp_cnt + 1;
                disp_tick <= 1'b0;
            end
        end
    end
endmodule


// ------------------------------
// Keypad scanner: 4x4 active-low columns/rows
// - One column active-low at a time (cols_out)
// - Samples rows on scan_tick
// - Registers at most one key per press; ignores additional while any key held.
// - Issues one-cycle key_valid pulse with 4-bit hex code (0..F) for the registered key.
// - Layout mapping below is configurable in code.
// ------------------------------
module keypad_scanner (
    input  logic clk,
    input  logic rst_n,
    input  logic scan_tick,              // from clk_divider
    input  logic [3:0] rows_n,           // active-low rows input (1 = not pressed, 0 = pressed)
    output logic [3:0] cols_n,           // active-low columns output (only one low at a time)
    output logic [3:0] key_code,         // 4-bit nibble for pressed key (valid when key_valid asserted)
    output logic key_valid               // single-cycle pulse when a new key is registered
);
    // Column scanning index 0..3
    logic [1:0] col_idx;

    // FSM states
    typedef enum logic [1:0] { KS_IDLE = 2'b00, KS_PRESSED = 2'b01, KS_WAIT_RELEASE = 2'b10 } ks_state_t;
    ks_state_t state, next_state;

    // mapping: rows (0..3) x cols (0..3) -> hex nibble
    // We'll define mapping as:
    // row0: 1  2  3  A
    // row1: 4  5  6  B
    // row2: 7  8  9  C
    // row3: E  0  F  D
    function automatic logic [3:0] map_to_hex(input logic [1:0] r, input logic [1:0] c);
        logic [3:0] code;
        unique case ({r,c})
            4'b00_00: code = 4'h1; // r0 c0 -> 1
            4'b00_01: code = 4'h2; // r0 c1 -> 2
            4'b00_10: code = 4'h3; // r0 c2 -> 3
            4'b00_11: code = 4'hA; // r0 c3 -> A
            4'b01_00: code = 4'h4;
            4'b01_01: code = 4'h5;
            4'b01_10: code = 4'h6;
            4'b01_11: code = 4'hB;
            4'b10_00: code = 4'h7;
            4'b10_01: code = 4'h8;
            4'b10_10: code = 4'h9;
            4'b10_11: code = 4'hC;
            4'b11_00: code = 4'hE; // star -> E
            4'b11_01: code = 4'h0;
            4'b11_10: code = 4'hF; // hash -> F
            4'b11_11: code = 4'hD;
            default: code = 4'h0;
        endcase
        return code;
    endfunction

    // seq: step a single column each scan_tick. cols_n is active-low with only selected column driven low.
    // For detection of release: require a full cycle (4 consecutive scan ticks) where sampled rows are all high.
    logic [2:0] no_press_count; // up to 4

    // sampled rows when current column is active (active-low)
    logic [3:0] sampled_rows_n;

    // store detected nibble for key when press first seen
    logic [3:0] latched_code;

    // generate current cols_n based on col_idx: active-low (0 selects)
    always_comb begin
        cols_n = 4'b1111;
        cols_n[col_idx] = 1'b0; // active-low selection
    end

    // synchronous state machine and column stepping
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= KS_IDLE;
            col_idx <= 2'd0;
            sampled_rows_n <= 4'b1111;
            key_valid <= 1'b0;
            latched_code <= 4'h0;
            no_press_count <= 3'd0;
            key_code <= 4'h0;
        end else begin
            key_valid <= 1'b0; // default, pulse only in same cycle press detected
            if (scan_tick) begin
                // sample the rows for the currently active column (they are active-low)
                sampled_rows_n <= rows_n;

                // state transitions and actions
                case (state)
                    KS_IDLE: begin
                        // if any row is active-low (pressed) on the current column -> register press
                        if (|(~sampled_rows_n)) begin
                            // find first row active in sampled_rows_n (priority low row index)
                            logic [1:0] r_i;
                            // choose first matching row (r0..r3)
                            if (!sampled_rows_n[0]) r_i = 2'd0;
                            else if (!sampled_rows_n[1]) r_i = 2'd1;
                            else if (!sampled_rows_n[2]) r_i = 2'd2;
                            else r_i = 2'd3;
                            latched_code <= map_to_hex(r_i, col_idx);
                            key_code <= map_to_hex(r_i, col_idx);
                            key_valid <= 1'b1;       // one-cycle pulse to indicate new key registered
                            state <= KS_WAIT_RELEASE; // go wait until fully released
                            no_press_count <= 3'd0;   // reset release counter
                        end else begin
                            // still idle; step to next column
                            col_idx <= col_idx + 1;
                            state <= KS_IDLE;
                        end
                    end

                    KS_WAIT_RELEASE: begin
                        // If sampled_rows_n shows no key pressed (all 1's) then increment no_press_count,
                        // When we see 4 consecutive column-samples with no press, consider released.
                        if (sampled_rows_n == 4'b1111) begin
                            no_press_count <= no_press_count + 1;
                            if (no_press_count >= 3'd3) begin
                                // 4 consecutive samples (counts: 0,1,2,3) -> release
                                state <= KS_IDLE;
                                no_press_count <= 3'd0;
                            end
                        end else begin
                            // still pressed somewhere; reset count and remain in wait_release
                            no_press_count <= 3'd0;
                        end
                        // always rotate column to continue full-cycle detection
                        col_idx <= col_idx + 1;
                    end

                    default: begin
                        state <= KS_IDLE;
                        col_idx <= col_idx + 1;
                    end
                endcase
            end // scan_tick
        end // !rst_n
    end // always_ff

endmodule


// ------------------------------
// Hex to 7-segment decoder (common-anode style; seg outputs active-low)
// - Input: nibble (0..F)
// - Output: seg[6:0] = {a,b,c,d,e,f,g} active-low (0 turns segment on)
// ------------------------------
module hex7seg (
    input  logic [3:0] nibble,
    output logic [6:0] seg_n
);
    // combinational mapping
    always_comb begin
        unique case (nibble)
            4'h0: seg_n = 7'b0000001; // segments a..g active-low: show 0 -> g off
            4'h1: seg_n = 7'b1001111;
            4'h2: seg_n = 7'b0010010;
            4'h3: seg_n = 7'b0000110;
            4'h4: seg_n = 7'b1001100;
            4'h5: seg_n = 7'b0100100;
            4'h6: seg_n = 7'b0100000;
            4'h7: seg_n = 7'b0001111;
            4'h8: seg_n = 7'b0000000;
            4'h9: seg_n = 7'b0000100;
            4'hA: seg_n = 7'b0001000; // A
            4'hB: seg_n = 7'b1100000; // b (lowercase)
            4'hC: seg_n = 7'b0110001;
            4'hD: seg_n = 7'b1000010; // d (lowercase)
            4'hE: seg_n = 7'b0110000;
            4'hF: seg_n = 7'b0111000;
            default: seg_n = 7'b1111111;
        endcase
    end
endmodule


// ------------------------------
// Top-level: connects everything
// - Maintains two hex digits: recent (most recent) and older
// - On key_valid: older <= recent; recent <= key_code
// - Time-multiplexes the two digits using disp_tick; toggles active digit each disp_tick
// - Balanced brightness: each digit receives equal on-time
// ------------------------------
module lab3_ai_prototype_qm #(
    parameter int OSC_FREQ_HZ = 20_000_000,
    parameter int SCAN_HZ     = 150,
    parameter int DISP_HZ     = 1000
) (
    input  logic clk,
    input  logic rst_n,             // active-low reset
    // keypad IO
    input  logic [3:0] rows_n,      // active-low rows from keypad
    output logic [3:0] cols_n,      // active-low columns to keypad
    // 7-seg IO
    output logic [6:0] seg_n,       // active-low segment outputs {a,b,c,d,e,f,g}
    output logic [1:0] digit_n      // active-low digit enables [1]=left MSB, [0]=right LSB
);

    // instantiate clock divider
    logic scan_tick;
    logic disp_tick;
    clk_divider #(.OSC_FREQ_HZ(OSC_FREQ_HZ), .SCAN_HZ(SCAN_HZ), .DISP_HZ(DISP_HZ)) clkdiv (
        .clk(clk), .rst_n(rst_n),
        .scan_tick(scan_tick), .disp_tick(disp_tick)
    );

    // keypad scanner
    logic [3:0] key_code;
    logic key_valid;
    keypad_scanner kscan (
        .clk(clk), .rst_n(rst_n),
        .scan_tick(scan_tick),
        .rows_n(rows_n),
        .cols_n(cols_n),
        .key_code(key_code),
        .key_valid(key_valid)
    );

    // two hex registers: recent (current) and older
    logic [3:0] digit_recent, digit_older;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            digit_recent <= 4'h0;
            digit_older  <= 4'h0;
        end else begin
            if (key_valid) begin
                digit_older  <= digit_recent;
                digit_recent <= key_code;
            end
        end
    end

    // display multiplex: toggle active digit at each disp_tick
    logic active_digit; // 0 -> right (LSB), 1 -> left (MSB)
    always_ff @(posedge clk) begin
        if (!rst_n) active_digit <= 1'b0;
        else if (disp_tick) active_digit <= ~active_digit;
    end

    // feed the appropriate nibble to the decoder and set digit enables
    logic [3:0] display_nibble;
    always_comb begin
        if (active_digit == 1'b0) begin
            // show right (least-significant) digit
            display_nibble = digit_recent;
            // digit_n active-low: 0->enable. For 2-digit common-anode,
            // digit_n[0] = 0 enables right digit, digit_n[1] = 1 disables left.
            digit_n = 2'b10;
        end else begin
            display_nibble = digit_older;
            digit_n = 2'b01;
        end
    end

    // segment decoder
    hex7seg decoder (.nibble(display_nibble), .seg_n(seg_n));

endmodule