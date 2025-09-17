/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 17, 2025

Purpose: To prove that the synchronized column signal arrives two cycles later as intended. 
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [3:0] keypad_column;
	logic [3:0] stabilized_column;
		
	// instantiates device under test
	keypad_column_synchronizer dut(clk, reset, keypad_column, stabilized_column);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 0; #22; reset = 1;
			
			// sets the column values and runs the clock for two full cycles
			keypad_column = 4'b1000; #20;
			
			// checks if the now-synchronized column output matches the input
			assert (stabilized_column === 4'b1000) else $display("Error!"); #3;
			
			// sets the column values and runs the clock for two full cycles
			keypad_column = 4'b0100; #20;
			
			// checks if the now-synchronized column output matches the input
			// repeats the process...
			assert (stabilized_column === 4'b0100) else $display("Error!"); #3;
			keypad_column = 4'b0010; #20; assert (stabilized_column === 4'b0010) else $display("Error!"); #3;
			keypad_column = 4'b0001; #20; assert (stabilized_column === 4'b0010) else $display("Error!");
		end
	
endmodule