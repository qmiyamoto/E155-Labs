/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 5, 2025

Purpose: To alternate transistor activation at a rate of 100 Hz.
*/

module time_multiplexer(input logic        internal_oscillator,
						 input logic        reset,
						 output logic [1:0] transistor);
	
	logic	  	 toggle;
	logic [23:0] counter;
	
	// simple clock divider
	always_ff @(posedge internal_oscillator, negedge reset)
		begin
			// zeroes out both the toggle indicator and the counter when a reset is enabled
			if (~reset)
				begin
					toggle <= 1'b0;
					counter <= 24'b0;
				end
				
			// toggles back and forth between transistors at a modified 100 Hz
			else if (counter < 24'd240000)
				counter <= counter + 1;
			
			else
				begin
					toggle <= ~toggle;
					counter <= 24'b0;
				end
		end
				
	// ensures that neither transistor is ever on at the same time
	assign transistor[0] = toggle;
	assign transistor[1] = ~toggle;
				
endmodule