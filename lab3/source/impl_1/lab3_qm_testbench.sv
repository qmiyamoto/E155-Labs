/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 17, 2025

Purpose: To provide a means of comparing the actual outputs of the entire Lab 3 top module with ideal/expected results;
		 additionally, to ensure that everything is properly connected in the top module.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [3:0] keypad_column, keypad_row;
	logic [1:0] transistor;
	logic [6:0] segment;
	
	// instantiates device under test
	lab3_qm dut(reset, keypad_column, keypad_row, transistor, segment);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 0; #22; reset = 1;
			
			// initializes all column inputs as zero
			keypad_column = 4'b0; #30;
			
			// simulates a button press by turning on Column 1 only when Row 0 is on, then "presses" Row 3, Column 1
			// checks if the transistors and 7-segment display outputs are correct
			wait(keypad_row[0]); keypad_column[1] = 1'b1; wait(~keypad_row[0]); keypad_column[1] = 1'b0; #12109948;
			wait(keypad_row[3]); keypad_column[1] = 1'b1; wait(~keypad_row[3]); keypad_column[1] = 1'b0;
			assert ((transistor === 2'b01) && (segment === 7'b0100100)) else $display("Error! The 7-segment display should be outputting two!");
		end
	
endmodule