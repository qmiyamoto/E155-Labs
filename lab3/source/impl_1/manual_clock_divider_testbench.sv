/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 17, 2025

Purpose: To prove that the clock divider halves the input signal as intended. 
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic halved_internal_oscillator;
		
	// instantiates device under test
	manual_clock_divider dut(clk, reset, halved_internal_oscillator);
	
	// generates clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	initial
		begin
			// pulses reset
			reset = 0; #22; reset = 1;
			
			// runs the clock (for 1 * 10 * 2 cycles) based off of previous clock-divider math
			#20;
			
			// checks if the halved_internal_oscillator signal has been toggled
			assert (halved_internal_oscillator === 1'b1) else $display("Error!");
			
			// runs the clock (for 1 * 10 * 2 cycles) based off of previous clock-divider math
			#20;
			
			// checks if the halved_internal_oscillator signal has been toggled
			// repeats the process...
			assert (halved_internal_oscillator === 1'b0) else $display("Error!"); #20;
			assert (halved_internal_oscillator === 1'b1) else $display("Error!"); #20;
			assert (halved_internal_oscillator === 1'b0) else $display("Error!");
		end
	
endmodule