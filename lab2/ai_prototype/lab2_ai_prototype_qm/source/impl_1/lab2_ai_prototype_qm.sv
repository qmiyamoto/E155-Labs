// Time-multiplex one seven-seg decoder across two 4-bit inputs,
// and drive two independent 7-bit (a..g) segment buses.
// Common-anode display (active-low segments).
module lab2_ai_prototype_qm #(
    // Clock and refresh parameters
    parameter int CLOCK_HZ   = 50_000_000,
    // Each digit is updated at REFRESH_HZ (per-digit rate). Visible refresh is 2*REFRESH_HZ.
    parameter int REFRESH_HZ = 1000
) (
    input  logic        clk,
    input  logic        rst_n,       // active-low reset
    input  logic [3:0]  nibble0,     // first hex digit (0..F)
    input  logic [3:0]  nibble1,     // second hex digit (0..F)
    output logic [6:0]  seg0,        // segments for digit 0: {a,b,c,d,e,f,g}, active-low
    output logic [6:0]  seg1         // segments for digit 1: {a,b,c,d,e,f,g}, active-low
);

    // ----------------------------------------------------------------------------
    // Clock divider to make the multiplexing tick
    // ----------------------------------------------------------------------------
    localparam int unsigned TICKS_PER_SLICE = (CLOCK_HZ / (REFRESH_HZ * 2)); // 2 slices: d0 then d1
    logic [$clog2(TICKS_PER_SLICE)-1:0] tick_ctr;
    logic                                slice_sel; // 0 -> update seg0 from nibble0, 1 -> update seg1 from nibble1

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_ctr  <= '0;
            slice_sel <= 1'b0;
        end else begin
            if (tick_ctr == TICKS_PER_SLICE-1) begin
                tick_ctr  <= '0;
                slice_sel <= ~slice_sel;
            end else begin
                tick_ctr <= tick_ctr + 1'b1;
            end
        end
    end

    // ----------------------------------------------------------------------------
    // Single shared decoder + slice-registered outputs
    // ----------------------------------------------------------------------------
    logic [3:0]  nibble_mux;
    logic [6:0]  seg_decoded; // active-low {a,b,c,d,e,f,g}

    always_comb begin
        nibble_mux = (slice_sel == 1'b0) ? nibble0 : nibble1;
        seg_decoded = seven_seg_decode_active_low(nibble_mux);
    end

    // Latch each digit's decoded value on its time slice
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seg0 <= 7'b111_1111; // all off (active-low)
            seg1 <= 7'b111_1111;
        end else begin
            if (slice_sel == 1'b0) seg0 <= seg_decoded; // update digit 0 this slice
            else                   seg1 <= seg_decoded; // update digit 1 this slice
        end
    end

    // ----------------------------------------------------------------------------
    // 4-bit hex to seven-seg (common-anode, active-LOW), order {a,b,c,d,e,f,g}
    // ----------------------------------------------------------------------------
    function automatic logic [6:0] seven_seg_decode_active_low (input logic [3:0] v);
        // Note: 0 = segment ON, 1 = segment OFF
        // Patterns are active-low inversions of the standard active-high abcdefg.
        case (v)
            4'h0: seven_seg_decode_active_low = 7'b000_0001; // 0
            4'h1: seven_seg_decode_active_low = 7'b100_1111; // 1
            4'h2: seven_seg_decode_active_low = 7'b001_0010; // 2
            4'h3: seven_seg_decode_active_low = 7'b000_0110; // 3
            4'h4: seven_seg_decode_active_low = 7'b100_1100; // 4
            4'h5: seven_seg_decode_active_low = 7'b010_0100; // 5
            4'h6: seven_seg_decode_active_low = 7'b010_0000; // 6
            4'h7: seven_seg_decode_active_low = 7'b000_1111; // 7
            4'h8: seven_seg_decode_active_low = 7'b000_0000; // 8
            4'h9: seven_seg_decode_active_low = 7'b000_0100; // 9
            4'hA: seven_seg_decode_active_low = 7'b000_1000; // A
            4'hB: seven_seg_decode_active_low = 7'b110_0000; // b
            4'hC: seven_seg_decode_active_low = 7'b011_0001; // C
            4'hD: seven_seg_decode_active_low = 7'b100_0010; // d
            4'hE: seven_seg_decode_active_low = 7'b011_0000; // E
            4'hF: seven_seg_decode_active_low = 7'b011_1000; // F
            default: seven_seg_decode_active_low = 7'b111_1111; // blank
        endcase
    endfunction

endmodule