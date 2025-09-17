/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 14, 2025

Purpose: To convert the 48 MHz internal oscillator signal to a 24 MHz one.
*/

module manual_clock_divider(input logic internal_oscillator,
							 input logic reset,
							 output logic halved_internal_oscillator);
		
	logic [1:0] counter;
	
	// simple clock divider
	always_ff @(posedge internal_oscillator, negedge reset)
		begin
			// zeroes out everything when a reset is enabled
			if (~reset)
				begin
					halved_internal_oscillator <= 1'b0;
					counter <= 2'b0;
				end
				
			// toggles the new halved oscillator signal at a modified 24 MHz
			else if (counter < 2'd1)
				counter <= counter + 2'd1;
				
			else
				begin
					halved_internal_oscillator <= ~halved_internal_oscillator;
					counter <= 2'b0;
				end
		end

endmodule