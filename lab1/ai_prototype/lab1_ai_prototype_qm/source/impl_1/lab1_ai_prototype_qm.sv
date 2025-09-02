//====================================================
// Blink LED at 2 Hz using Lattice UP5K internal HFOSC
//====================================================
module led_blinker (
    output logic led    // Active-high LED output
);

    // -----------------------------------------------
    // Internal HFOSC: default ~48 MHz, can divide
    // DIV bits:
    //   "00" = ÷1  → 48 MHz
    //   "01" = ÷2  → 24 MHz
    //   "10" = ÷4  → 12 MHz
    //   "11" = ÷8  →  6 MHz
    // -----------------------------------------------
    logic clk_int;

	SB_HFOSC #(
		.CLKHF_DIV("0b10")   // ÷4 → 12 MHz
	) u_hfosc (
		.CLKHFEN (1'b1),     // Enable oscillator
		.CLKHFPU (1'b1),     // Power up oscillator
		.CLKHF   (clk_int)
	);


    //SB_HFOSC #(
        //.CLKHF_DIV("0b10")   // Divide by 4 → 12 MHz
    //) u_hfosc (
        //.CLKHFEN (1'b1),     // Enable oscillator
        //.CLKHFPU (1'b1),     // Power up oscillator
        //.CLKHF   (clk_int)
    //);

    // -----------------------------------------------
    // Clock divider for ~2 Hz blink
    // -----------------------------------------------
    localparam int FREQ_HZ     = 12_000_000; // 12 MHz
    localparam int BLINK_HZ    = 2;          // 2 Hz
    localparam int HALF_PERIOD = FREQ_HZ / (2*BLINK_HZ);
    // → 12_000_000 / 4 = 3_000_000 cycles per toggle

    logic [$clog2(HALF_PERIOD)-1:0] counter = '0;

    always_ff @(posedge clk_int) begin
        if (counter == HALF_PERIOD-1) begin
            counter <= '0;
            led     <= ~led;   // toggle LED
        end
        else begin
            counter <= counter + 1;
        end
    end

endmodule
