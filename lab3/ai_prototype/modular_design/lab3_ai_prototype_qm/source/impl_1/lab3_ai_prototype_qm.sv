module key_register #(
    parameter DEBOUNCE_COUNT = 20  // number of scan_clk cycles to confirm press/release
) (
    input  logic        clk,        // system clock
    input  logic        rst,        // async reset, active high
    input  logic        scan_clk,   // slow scan clock (~100-200 Hz)
    input  logic [3:0]  key_in,     // sampled key code from scanner (0x0–0xF), valid only if key_valid=1
    input  logic        key_valid,  // high if scanner sees exactly one pressed key
    output logic        new_key,    // one-cycle strobe on clk
    output logic [3:0]  key_code    // latched key code of last press
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,        // no key pressed
        DEBOUNCE,    // waiting for stable key press
        HELD,        // key held down
        RELEASE      // waiting for stable release
    } state_t;

    state_t state, next_state;

    logic [3:0]  key_buf;      // candidate key code during debounce
    logic [$clog2(DEBOUNCE_COUNT):0] cnt;  // debounce counter
    logic        cnt_done;

    // counter done flag
    assign cnt_done = (cnt == DEBOUNCE_COUNT);

    // sequential FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state    <= IDLE;
            key_code <= 4'd0;
            new_key  <= 1'b0;
            key_buf  <= 4'd0;
            cnt      <= '0;
        end else begin
            state    <= next_state;
            new_key  <= 1'b0;  // default, pulse only when asserted

            case (state)
                IDLE: begin
                    cnt <= '0;
                    if (key_valid) begin
                        key_buf <= key_in;
                        cnt     <= 1;
                    end
                end

                DEBOUNCE: begin
                    if (!key_valid) begin
                        cnt <= '0;  // aborted
                    end else if (key_in != key_buf) begin
                        cnt <= 1;    // restart for new candidate
                        key_buf <= key_in;
                    end else if (!cnt_done) begin
                        cnt <= cnt + 1;
                    end else begin
                        // confirmed
                        key_code <= key_buf;
                        new_key  <= 1'b1;
                    end
                end

                HELD: begin
                    cnt <= '0;
                end

                RELEASE: begin
                    if (key_valid) begin
                        cnt <= '0;  // restart if pressed again
                    end else if (!cnt_done) begin
                        cnt <= cnt + 1;
                    end
                end
            endcase
        end
    end

    // next-state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (key_valid)
                    next_state = DEBOUNCE;
            end

            DEBOUNCE: begin
                if (!key_valid)
                    next_state = IDLE;
                else if (cnt_done)
                    next_state = HELD;
            end

            HELD: begin
                if (!key_valid) begin
                    next_state = RELEASE;
                end
            end

            RELEASE: begin
                if (key_valid)
                    next_state = DEBOUNCE;
                else if (cnt_done)
                    next_state = IDLE;
            end
        endcase
    end

endmodule

module keypad_scanner #(
    parameter SCAN_DIV = 16'd5000   // adjust for ~1 kHz scan clock from system clk
) (
    input  logic        clk,        // system clock
    input  logic        rst,        // async reset, active high
    output logic [3:0]  col_n,      // active-low column drives
    input  logic [3:0]  row_n,      // active-low row inputs
    output logic        key_valid,  // high if a key is pressed
    output logic [3:0]  key_code    // stable key code (0-F)
);

    // Clock divider to generate scan tick
    logic [$clog2(SCAN_DIV)-1:0] divcnt;
    logic scan_tick;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            divcnt   <= '0;
            scan_tick <= 1'b0;
        end else begin
            if (divcnt == SCAN_DIV-1) begin
                divcnt   <= '0;
                scan_tick <= 1'b1;
            end else begin
                divcnt   <= divcnt + 1;
                scan_tick <= 1'b0;
            end
        end
    end

    // Column index (0..3)
    logic [1:0] col_idx;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            col_idx <= 2'd0;
        end else if (scan_tick) begin
            col_idx <= col_idx + 1;
        end
    end

    // Active-low column output (one-hot)
    always_comb begin
        col_n = 4'b1111;
        col_n[col_idx] = 1'b0;
    end

    // Row sample registers
    logic [3:0] row_sample;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            row_sample <= 4'b1111;
        end else if (scan_tick) begin
            row_sample <= row_n;
        end
    end

    // Decode key when row goes low
    logic [3:0] code_next;
    logic       valid_next;

    always_comb begin
        code_next  = 4'd0;
        valid_next = 1'b0;

        unique case (col_idx)
            2'd0: begin
                casez (row_sample)
                    4'b1110: begin code_next=4'h1; valid_next=1'b1; end
                    4'b1101: begin code_next=4'h4; valid_next=1'b1; end
                    4'b1011: begin code_next=4'h7; valid_next=1'b1; end
                    4'b0111: begin code_next=4'hE; valid_next=1'b1; end // *
                endcase
            end
            2'd1: begin
                casez (row_sample)
                    4'b1110: begin code_next=4'h2; valid_next=1'b1; end
                    4'b1101: begin code_next=4'h5; valid_next=1'b1; end
                    4'b1011: begin code_next=4'h8; valid_next=1'b1; end
                    4'b0111: begin code_next=4'h0; valid_next=1'b1; end
                endcase
            end
            2'd2: begin
                casez (row_sample)
                    4'b1110: begin code_next=4'h3; valid_next=1'b1; end
                    4'b1101: begin code_next=4'h6; valid_next=1'b1; end
                    4'b1011: begin code_next=4'h9; valid_next=1'b1; end
                    4'b0111: begin code_next=4'hF; valid_next=1'b1; end // #
                endcase
            end
            2'd3: begin
                casez (row_sample)
                    4'b1110: begin code_next=4'hA; valid_next=1'b1; end
                    4'b1101: begin code_next=4'hB; valid_next=1'b1; end
                    4'b1011: begin code_next=4'hC; valid_next=1'b1; end
                    4'b0111: begin code_next=4'hD; valid_next=1'b1; end
                endcase
            end
        endcase
    end

    // Register stable outputs
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            key_code  <= 4'd0;
            key_valid <= 1'b0;
        end else if (valid_next) begin
            key_code  <= code_next;
            key_valid <= 1'b1;
        end else if (&row_sample) begin
            // all rows inactive = no key
            key_valid <= 1'b0;
        end
    end

endmodule

module lab3_ai_prototype_qm (
    input  logic        clk,       // 20 MHz HFOSC root clock
    input  logic        rst,       // async reset
    // keypad I/O
    output logic [3:0]  col_n,     // drive columns (active low)
    input  logic [3:0]  row_n,     // read rows (active low)
    // seven-seg display
    output logic [6:0]  seg,       // segment outputs (a..g)
    output logic [1:0]  dig_en     // active-high digit enables [0]=right, [1]=left
);

    //----------------------------------------------------------------------
    // Clock enables
    //----------------------------------------------------------------------
    localparam int SCAN_DIV = 20000; // ~1 kHz from 20 MHz
    localparam int MUX_DIV  = 5000;  // ~4 kHz multiplex tick

    logic [$clog2(SCAN_DIV)-1:0] scan_cnt;
    logic [$clog2(MUX_DIV)-1:0]  mux_cnt;
    logic scan_tick, mux_tick;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            scan_cnt <= '0;
            scan_tick <= 1'b0;
            mux_cnt  <= '0;
            mux_tick <= 1'b0;
        end else begin
            // scan clock enable
            if (scan_cnt == SCAN_DIV-1) begin
                scan_cnt <= '0;
                scan_tick <= 1'b1;
            end else begin
                scan_cnt <= scan_cnt + 1;
                scan_tick <= 1'b0;
            end
            // display multiplex clock enable
            if (mux_cnt == MUX_DIV-1) begin
                mux_cnt <= '0;
                mux_tick <= 1'b1;
            end else begin
                mux_cnt <= mux_cnt + 1;
                mux_tick <= 1'b0;
            end
        end
    end

    //----------------------------------------------------------------------
    // Keypad scanner
    //----------------------------------------------------------------------
    logic        scan_key_valid;
    logic [3:0]  scan_key_code;

    keypad_scanner #(.SCAN_DIV(1)) scanner ( // SCAN_DIV unused here; driven by scan_tick
        .clk       (clk),
        .rst       (rst),
        .col_n     (col_n),
        .row_n     (row_n),
        .key_valid (scan_key_valid),
        .key_code  (scan_key_code)
    );

    //----------------------------------------------------------------------
    // One-shot key register
    //----------------------------------------------------------------------
    logic        new_key;
    logic [3:0]  reg_key_code;

    key_register #(.DEBOUNCE_COUNT(4)) one_shot (
        .clk       (clk),
        .rst       (rst),
        .scan_clk  (scan_tick),
        .key_in    (scan_key_code),
        .key_valid (scan_key_valid),
        .new_key   (new_key),
        .key_code  (reg_key_code)
    );

    //----------------------------------------------------------------------
    // Two-key shift register
    //----------------------------------------------------------------------
    logic [3:0] digit_left, digit_right;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_left  <= 4'h0;
            digit_right <= 4'h0;
        end else if (new_key) begin
            digit_left  <= digit_right;   // older digit shifts left
            digit_right <= reg_key_code;  // newest digit on right
        end
    end

    //----------------------------------------------------------------------
    // Seven-segment decoding
    //----------------------------------------------------------------------
    logic [6:0] seg_left, seg_right;

    SevenSegment decode_left  (.digit(digit_left),  .segment(seg_left));
    SevenSegment decode_right (.digit(digit_right), .segment(seg_right));

    //----------------------------------------------------------------------
    // Display multiplexing
    //----------------------------------------------------------------------
    logic mux_sel; // 0 = right, 1 = left

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mux_sel <= 1'b0;
        end else if (mux_tick) begin
            mux_sel <= ~mux_sel;
        end
    end

    always_comb begin
        case (mux_sel)
            1'b0: begin
                seg    = seg_right;
                dig_en = 2'b01;   // enable right digit
            end
            1'b1: begin
                seg    = seg_left;
                dig_en = 2'b10;   // enable left digit
            end
        endcase
    end

endmodule
