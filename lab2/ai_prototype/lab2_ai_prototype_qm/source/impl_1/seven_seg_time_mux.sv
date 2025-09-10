// Time-multiplex a single seven_segment_display decoder across two inputs,
// producing two independent 7-seg outputs (common-anode, active-low pattern
// assumed to match your provided decoder).
//
// How it works (one flip per "tick"):
// 1) Present selected nibble (A or B) to the single decoder.
// 2) Latch the decoder's comb output into seg_a or seg_b (according to which input
//    was selected *this* tick).
// 3) Toggle selection for the next tick.
//
// The outputs seg_a/seg_b remain stable between updates, so each display sees a
// steady 7-bit pattern even though only one decoder is used.

module sevenseg_time_mux #(
    // Number of clk cycles between multiplex "ticks".
    // Choose to hit ~0.5–5 kHz depending on your board clock so both digits look steady.
    parameter int unsigned DIVIDE = 50_000  // e.g., 50k @ 50 MHz -> ~1 kHz tick
) (
    input  logic        clk,
    input  logic        reset,      // synchronous, active-high
    input  logic [3:0]  a,          // nibble for display A
    input  logic [3:0]  b,          // nibble for display B
    output logic [6:0]  seg_a,      // 7-seg outputs for digit A (GFEDCBA)
    output logic [6:0]  seg_b       // 7-seg outputs for digit B (GFEDCBA)
);

    // ----------------------------------------------------------------------------
    // Clock divider to create the multiplex "tick"
    // ----------------------------------------------------------------------------
    localparam int unsigned CNT_W = (DIVIDE <= 1) ? 1 : $clog2(DIVIDE);
    logic [CNT_W-1:0] div_cnt;
    logic             tick;

    always_ff @(posedge clk) begin
        if (reset) begin
            div_cnt <= '0;
            tick    <= 1'b0;
        end else begin
            if (div_cnt == DIVIDE-1) begin
                div_cnt <= '0;
                tick    <= 1'b1;
            end else begin
                div_cnt <= div_cnt + 1'b1;
                tick    <= 1'b0;
            end
        end
    end

    // ----------------------------------------------------------------------------
    // Single decoder instance + input select
    // ----------------------------------------------------------------------------
    logic        sel;         // 0 -> decode A this tick, 1 -> decode B this tick
    logic [3:0]  s_mux;
    logic [6:0]  seg_decoded;

    assign s_mux = (sel == 1'b0) ? a : b;

    // Use the provided decoder exactly once
    seven_segment_display u_dec (
        .s   (s_mux),
        .seg (seg_decoded)
    );

    // ----------------------------------------------------------------------------
    // Latch decoded outputs to each digit on each tick; then toggle selection
    // ----------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            sel    <= 1'b0;
            seg_a  <= 7'h7F;  // all off for common-anode active-low
            seg_b  <= 7'h7F;
        end else if (tick) begin
            if (sel == 1'b0) begin
                seg_a <= seg_decoded; // we decoded A this tick
            end else begin
                seg_b <= seg_decoded; // we decoded B this tick
            end
            sel <= ~sel;               // switch to the other input for next tick
        end
    end

endmodule
