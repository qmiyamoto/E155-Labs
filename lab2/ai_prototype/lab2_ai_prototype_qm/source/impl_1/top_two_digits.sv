module top_two_digits (
    input  logic        clk,     // from your board oscillator/PLL
    input  logic        reset,   // sync, active-high
    input  logic [3:0]  sA,      // first nibble (e.g., SW[3:0])
    input  logic [3:0]  sB,      // second nibble (e.g., SW[7:4] or other source)
    output logic [6:0]  segA,    // wire to digit A segments (GFEDCBA)
    output logic [6:0]  segB     // wire to digit B segments (GFEDCBA)
);

    // One decoder, two displays — time-multiplexed:
    sevenseg_time_mux #(
        .DIVIDE(50_000)          // adjust for your board clock
    ) mux2 (
        .clk   (clk),
        .reset (reset),
        .a     (sA),
        .b     (sB),
        .seg_a (segA),
        .seg_b (segB)
    );

endmodule
