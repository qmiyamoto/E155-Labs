/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 14, 2025

Purpose: To provide a means of comparing the actual key outputs of simulated button presses with ideal/expected results. 
*/

`timescale 1 ns / 1 ps

module testbench();
	
	logic clk;
	logic reset;
	
	logic [3:0] keypad_column, keypad_row;
	logic [7:0] most_recent_key, second_most_recent_key;
		
	// instantiates device under test
	keypad_scanner_and_debouncer dut(clk, reset, keypad_column, keypad_row, most_recent_key, second_most_recent_key);
	
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
			keypad_column = 4'b0;
			
			// simulates a button press by turning on Column 1 only when Row 3 is on, then checks if the key outputs are correct
			wait(keypad_row[3]); keypad_column[1] = 1'b1; wait(~keypad_row[3]); keypad_column[1] = 1'b0; #12000075;
			assert ((most_recent_key === 8'b1000_0010) & (second_most_recent_key === 8'b0000_0000)) else $display("Error! The two most recent keys pressed should be one and zero!");
			
			// resets all columns to zero
			keypad_column = 4'b0;
			
			// simulates a button press by turning on Column 1 only when Row 0 is on, then checks if the key outputs are correct
			wait(keypad_row[0]); keypad_column[1] = 1'b1; wait(~keypad_row[0]); keypad_column[1] = 1'b0; #12000075;
			assert ((most_recent_key === 8'b0001_0010) && (second_most_recent_key === 8'b1000_0010)) else $display("Error! The two most recent keys pressed should be two and one!");
				
			// resets all columns to zero
			keypad_column = 4'b0;
			
			// simulates an initial button press by turning on Column 2 only when Row 0 is on
			// simulates a second button press by turning on Column 0 for a brief period of time afterward, before checking if only the initial press is registered
			wait(keypad_row[0]); keypad_column[2] = 1'b1; wait(~keypad_row[0]); keypad_column[2] = 1'b0; #15;
			keypad_column[0] = 1'b1; #50; keypad_column[0] = 1'b0; #12000005;
			assert ((most_recent_key === 8'b0001_0100) && (second_most_recent_key === 8'b0001_0010)) else $display("Error! The two most recent keys pressed should be three and two!");
				
			// resets all columns to zero
			keypad_column = 4'b0;
			
			// simulates an initial button press by turning on Column 3 only when Row 0 is on
			// simulates a second button press by turning on Column 1 for a brief period of time afterward, before checking if only the initial press is registered
			wait(keypad_row[0]); keypad_column[3] = 1'b1; wait(~keypad_row[0]); keypad_column[3] = 1'b0; #15;
			keypad_column[1] = 1'b1; #50; keypad_column[1] = 1'b0; #12000005;
			assert ((most_recent_key === 8'b0001_1000) && (second_most_recent_key === 8'b0001_0100)) else $display("Error! The two most recent keys pressed should be A and three!");	
			
			// resets all columns to zero
			keypad_column = 4'b0;
			
			// simulates an initial button press by turning on Column 3 only when Row 3 is on
			// simulates a second, longer button press by turning on Column 0 and turning off Column 3, before checking if the second press is indeed registered
			wait(keypad_row[3]); keypad_column[3] = 1'b1; wait(~keypad_row[3]); keypad_column[3] = 1'b0; #12000005;
			keypad_column[0] = 1'b1; #12000075; keypad_column[0] = 1'b0; #12000075;
			assert ((most_recent_key === 8'b0100_0001) && (second_most_recent_key === 8'b1000_1000)) else $display("Error! The two most recent keys pressed should be seven and D!");	
		end
	
endmodule