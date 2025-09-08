/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 6, 2025

Purpose: To provide a means of comparing the actual outputs of the entire Lab 2 top module with ideal/expected results;
		 additionally, to ensure that everything is properly connected in the top module.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [7:0] switch;
	logic [6:0] segment;
	logic [4:0] led;
	logic [1:0] transistor;
	
	// instantiates device under test
	lab2_qm dut(reset, switch, segment, led, transistor);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 0; #22; reset = 1;
			
			// sets switches and runs the clock (for 240,000 * 10 cycles * 2) based off of previous clock-divider math
			switch = 8'b0100_1111; #4800000;
			
			// checks if the correct transistor has been turned on
			assert (transistor === 2'b10) else $display("Error with the transistors! The result is supposed to be 2'b10!");
				
			// checks to see whether the 7-segment display looks as intended
			assert (segment === 7'b0000011) else $display("Error with the 7-segment display! The digit is supposed to be b!");
				
			// checks the summed LED results
			// b + 0 = 11
			assert (led === 5'b01011) else $display("Error with math! b + 0 is supposed to equal 11!");
			
			// sets switches and runs the clock (for 240,000 * 10 cycles) based off of previous clock-divider math
			// repeats the process...
			switch = 8'b0111_1001; #4800000;
			
			assert (transistor === 2'b01) else $display("Error with the transistors! The result is supposed to be 2'b01!");
			assert (segment === 7'b0000010) else $display("Error with the 7-segment display! The digit is supposed to be 6!");
			
			// 8 + 6 = 14
			assert (led === 5'b01110) else $display("Error! 8 + 6 is supposed to equal 14!");
			
			switch = 8'b0110_0110; #4800000;
			assert (transistor === 2'b10) else $display("Error with the transistors! The result is supposed to be 2'b01!");
			assert (segment === 7'b0011000) else $display("Error with the 7-segment display! The digit is supposed to be 9!");
				
			// 9 + 9 = 18
			assert (led === 5'b10010) else $display("Error! 9 + 9 is supposed to equal 18!");
		end
	
endmodule