/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 6, 2025

Purpose: To provide a means of comparing the actual toggling of the transistors with ideal/expected results.
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [1:0] transistor;
			
	// instantiates device under test
	seven_segment_display_multiplexer dut(clk, reset, transistor);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 0; #22; reset = 1;
			
			// runs the clock (for 240,000 * 10 cycles) based off of previous clock-divider math
			#2400000;
			
			// checks if the correct transistor has been turned on
			assert (transistor === 2'b10) else $display("Error!");
			
			// runs the clock (for 240,000 * 10 cycles) based off of previous clock-divider math
			#2400000;
			
			// checks if the correct transistor has been turned on
			// repeats the process...
			assert (transistor === 2'b01) else $display("Error!"); #2400000;
			assert (transistor === 2'b10) else $display("Error!"); #2400000;
			assert(transistor === 2'b01) else $display("Error!");
		end
		
endmodule