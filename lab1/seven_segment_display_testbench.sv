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
	
	logic [3:0] s;
	logic [6:0] seg;
	
	logic [6:0] seg_expected;
	
	logic [31:0] vector_num, errors;
	logic [10:0] test_vectors[10000:0];
	
	// instantiates device under test
	seven_segment_display dut(s, seg);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// loads vectors at the start of the test, and pulses reset
	initial
		begin
			$readmemb("./seven_segment_display_test_vectors.txt", test_vectors);
			vector_num = 0; errors = 0;
			reset = 1; #22; reset = 0;
		end
		
	// applies test vectors on the rising edge of the clock
	always @(posedge clk)
		begin
			#1; {s, seg_expected} = test_vectors[vector_num];
		end
		
	// checks the results on the falling edge of the clock
	always @(negedge clk)
		// skips the following checks during resets
		if (~reset)
			begin
				// checks if the actual results match the intended ones
				if (seg !== seg_expected)
					begin
						$display("Error: inputs = %b", {s});
						$display("outputs = %b (%b expected)", seg, seg_expected);
						errors = errors + 1;
					end
					
				vector_num = vector_num + 1;
				
				if (test_vectors[vector_num] === 11'bx)
					begin
						$display("%d tests completed with %d errors", vector_num, errors);
						$stop;
					end
			end
		
endmodule    