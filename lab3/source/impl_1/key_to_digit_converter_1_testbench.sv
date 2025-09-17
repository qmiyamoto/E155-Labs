/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 14, 2025

Purpose: To provide a means of comparing the actual digit outputs of the pressed keys with ideal/expected results.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [7:0] key;
	logic [3:0] digit;
		
	// instantiates device under test
	key_to_digit_converter_1 dut(key, digit);
	
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
			
			// simulates key inputs and checks that the converted digits are correct
			key = 8'b0001_0001; #10; assert (digit === 4'b0001) else $display("Error! The output should be 1!"); #10;
			key = 8'b0001_0010; #10; assert (digit === 4'b0010) else $display("Error! The output should be 2!"); #10;
			key = 8'b0001_0100; #10; assert (digit === 4'b0011) else $display("Error! The output should be 3!"); #10;
			key = 8'b0001_1000; #10; assert (digit === 4'b1010) else $display("Error! The output should be A!"); #10;
			key = 8'b0010_0001; #10; assert (digit === 4'b0100) else $display("Error! The output should be 4!"); #10;
			key = 8'b0010_0010; #10; assert (digit === 4'b0101) else $display("Error! The output should be 5!"); #10;
			key = 8'b0010_0100; #10; assert (digit === 4'b0110) else $display("Error! The output should be 6!"); #10;
			key = 8'b0010_1000; #10; assert (digit === 4'b1011) else $display("Error! The output should be B!"); #10;
			key = 8'b0100_0001; #10; assert (digit === 4'b0111) else $display("Error! The output should be 7!"); #10;
			key = 8'b0100_0010; #10; assert (digit === 4'b1000) else $display("Error! The output should be 8!"); #10;
			key = 8'b0100_0100; #10; assert (digit === 4'b1001) else $display("Error! The output should be 9!"); #10;
			key = 8'b0100_1000; #10; assert (digit === 4'b1100) else $display("Error! The output should be C!"); #10;
			key = 8'b1000_0001; #10; assert (digit === 4'b1110) else $display("Error! The output should be E!"); #10;
			key = 8'b1000_0010; #10; assert (digit === 4'b0000) else $display("Error! The output should be 0!"); #10;
			key = 8'b1000_0100; #10; assert (digit === 4'b1111) else $display("Error! The output should be F!"); #10;
			key = 8'b1000_1000; #10; assert (digit === 4'b1101) else $display("Error! The output should be D!"); #10;
		end
	
endmodule    