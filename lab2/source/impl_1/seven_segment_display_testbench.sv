/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  August 29, 2025

Purpose: To provide a means of comparing the actual output of the segments with ideal/expected results.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [3:0] switch;
	logic [6:0] segment;
	
	logic [6:0] segment_expected;
	
	logic [31:0] vector_num, errors;
	logic [10:0] testvectors[10000:0];
	
	// instantiates device under test
	seven_segment_display dut(switch, segment);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// loads vectors at the start of the test, and pulses reset
	initial
		begin
			$readmemb("./seven_segment_display_testvectors.txt", testvectors);
			vector_num = 0; errors = 0;
			reset = 1; #22; reset = 0;
		end
		
	// applies test vectors on the rising edge of the clock
	always @(posedge clk)
		begin
			#1; {switch, segment_expected} = testvectors[vector_num];
		end
		
	// checks the results on the falling edge of the clock
	always @(negedge clk)
		// skips the following checks during resets
		if (~reset)
			begin
				// checks if the actual results match the intended ones
				if (segment !== segment_expected)
					begin
						$display("Error: inputs = %b", {switch});
						$display("outputs = %b (%b expected)", segment, segment_expected);
						errors = errors + 1;
					end
					
				vector_num = vector_num + 1;
				
				if (testvectors[vector_num] === 11'bx)
					begin
						$display("%d tests completed with %d errors", vector_num, errors);
						$stop;
					end
			end
		
endmodule    