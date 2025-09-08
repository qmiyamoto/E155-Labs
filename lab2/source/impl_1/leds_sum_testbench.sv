/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 5, 2025

Purpose: To provide a means of comparing the actual sums of the switch-controlled inputs with ideal/expected results.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [7:0] switch;
	logic [4:0] led;
		
	// instantiates device under test
	leds_sum dut(switch, led);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 1; #22; reset = 0;
			
			#10;
			
			// sets switches and checks the summed LED results
			// b + 0 = 11
			switch = 8'b0100_1111; #10;
			assert (led === 5'b01011) else $display("Error! b + 0 is supposed to equal 11!");
											
			// 8 + 6 = 14
			switch = 8'b0111_1001; #10;
			assert (led === 5'b01110) else $display("Error! 8 + 6 is supposed to equal 14!");
										
			// 9 + 9 = 18
			switch = 8'b0110_0110; #10;
			assert (led === 5'b10010) else $display("Error! 9 + 9 is supposed to equal 18!");
			
			// C + F = 27
			switch = 8'b0011_0000; #10;
			assert (led === 5'b11011) else $display("Error! C + F is supposed to equal 27!");
							
			// 2 + 3 = 5
			switch = 8'b1101_1100; #10;
			assert (led === 5'b00101) else $display("Error! 2 + 3 is supposed to equal 5!");
										
			// E + 1 = 15
			switch = 8'b0001_1110; #10;
			assert (led === 5'b01111) else $display("Error! E + 1 is supposed to equal 15!");
										
			// d + d = 26
			switch = 8'b0010_0010; #10;
			assert (led === 5'b11010) else $display("Error! d + d is supposed to equal 26!");
										
			// 4 + 7 = 11
			switch = 8'b1011_1000; #10;
			assert (led === 5'b01011) else $display("Error! 4 + 7 is supposed to equal 11!");
										
			// F + F = 30
			switch = 8'b0000_0000; #10;
			assert (led === 5'b11110) else $display("Error! F + F is supposed to equal 30!");
										
			// 0 + 0 = 0
			switch = 8'b1111_1111; #10;
			assert (led === 5'b00000) else $display("Error! 0 + 0 is supposed to equal 0!");
		end
	
endmodule    