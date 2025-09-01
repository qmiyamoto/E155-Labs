/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  August 27, 2025

Purpose: To toggle the on-board LEDs according to the Lab One instructions.
		 (In this case, LED 2 must blink at a constant 2.4 Hz, while LEDs 0 and 1 depend on the positions of the SW6 DIP switches;
		 see below for further details regarding the latter.)
*/

module on_board_leds(input logic        clk,
					 input logic        reset,
					 input logic  [3:0] s,
					 output logic [2:0] led);
					 
	logic 	     int_osc;
	logic [23:0] counter;
			   
	// internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
    // simple clock divider
	always_ff @(posedge int_osc)
		begin
			// zeroes out both LED 2 and the counter when a reset is enabled
			if (~reset)
				begin
					led[2] <= 1'b0;
					counter <= 24'b0;
				end

			// blinks LED 2 at a modified 2.4 Hz
			else if (counter < 24'd10000000)
				counter <= counter + 1;	 
				
			else
				begin
					led[2] <= ~led[2];
					counter <= 24'b0;
				end
		end
	
	// blinks LED 1 when both switches 2 and 3 are toggled on
	// note: LED 1 is effectively an AND gate
	assign led[1] = (~s[2] & ~s[3]);
	
	// blinks LED 0 when either switch 0 or switch 1 are on, but not at the same time
	// note: LED 0 is effectively a XOR gate
	assign led[0] = (~s[0] ^ ~s[1]);
	
endmodule