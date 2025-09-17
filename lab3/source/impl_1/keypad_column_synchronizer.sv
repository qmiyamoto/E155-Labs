/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 13, 2025

Purpose: To synchronize the asynchronous keypad column inputs and ultimately mitigate metastability.
*/

module keypad_column_synchronizer(input logic  	  internal_oscillator,
								   input logic  	  reset,
								   input logic  [3:0] keypad_column,
								   output logic [3:0] stabilized_column);
	
	logic [3:0] metastable_column;
	
	// delays the keypad_scanner_and_debouncer module's receival of the keypad_column input signal until two clock cycles later
	always_ff @(posedge internal_oscillator, negedge reset)
		begin
			// zeroes out everything when a reset is enabled
			if (~reset)
				begin
					metastable_column <= 4'b0;
					stabilized_column <= 4'b0;
				end
			
			// passes the keypad_column signal through, essentially, two flip-flops
			else
				begin
					metastable_column <= keypad_column;
					stabilized_column <= metastable_column;
				end
					
		end
		
endmodule