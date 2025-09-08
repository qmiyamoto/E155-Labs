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
			
			switch = 8'b1111_1111; #10; assert (led === 5'b00000) else $display("Error!"); #10;		// 0 + 0
			switch = 8'b1110_1111; #10; assert (led === 5'b00001) else $display("Error!"); #10;		// 1 + 0
			switch = 8'b1101_1111; #10; assert (led === 5'b00010) else $display("Error!"); #10;		// 2 + 0
			switch = 8'b1100_1111; #10; assert (led === 5'b00011) else $display("Error!"); #10;		// 3 + 0
			switch = 8'b1011_1111; #10; assert (led === 5'b00100) else $display("Error!"); #10;		// 4 + 0
			switch = 8'b1010_1111; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 5 + 0
			switch = 8'b1001_1111; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 6 + 0
			switch = 8'b1000_1111; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 7 + 0
			switch = 8'b0111_1111; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 8 + 0
			switch = 8'b0110_1111; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 9 + 0
			switch = 8'b0101_1111; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// A + 0
			switch = 8'b0100_1111; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// b + 0
			switch = 8'b0011_1111; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// C + 0 
			switch = 8'b0010_1111; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// d + 0
			switch = 8'b0001_1111; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// E + 0
			switch = 8'b0000_1111; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// F + 0
			
			switch = 8'b1111_1110; #10; assert (led === 5'b00001) else $display("Error!"); #10;		// 0 + 1
			switch = 8'b1110_1110; #10; assert (led === 5'b00010) else $display("Error!"); #10;		// 1 + 1
			switch = 8'b1101_1110; #10; assert (led === 5'b00011) else $display("Error!"); #10;		// 2 + 1
			switch = 8'b1100_1110; #10; assert (led === 5'b00100) else $display("Error!"); #10;		// 3 + 1
			switch = 8'b1011_1110; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 4 + 1
			switch = 8'b1010_1110; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 5 + 1
			switch = 8'b1001_1110; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 6 + 1
			switch = 8'b1000_1110; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 7 + 1
			switch = 8'b0111_1110; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 8 + 1
			switch = 8'b0110_1110; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 9 + 1
			switch = 8'b0101_1110; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// A + 1
			switch = 8'b0100_1110; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// b + 1
			switch = 8'b0011_1110; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// C + 1 
			switch = 8'b0010_1110; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// d + 1
			switch = 8'b0001_1110; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// E + 1
			switch = 8'b0000_1110; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// F + 1
			
			switch = 8'b1111_1101; #10; assert (led === 5'b00010) else $display("Error!"); #10;		// 0 + 2
			switch = 8'b1110_1101; #10; assert (led === 5'b00011) else $display("Error!"); #10;		// 1 + 2
			switch = 8'b1101_1101; #10; assert (led === 5'b00100) else $display("Error!"); #10;		// 2 + 2
			switch = 8'b1100_1101; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 3 + 2
			switch = 8'b1011_1101; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 4 + 2
			switch = 8'b1010_1101; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 5 + 2
			switch = 8'b1001_1101; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 6 + 2
			switch = 8'b1000_1101; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 7 + 2
			switch = 8'b0111_1101; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 8 + 2
			switch = 8'b0110_1101; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 9 + 2
			switch = 8'b0101_1101; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// A + 2
			switch = 8'b0100_1101; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// b + 2
			switch = 8'b0011_1101; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// C + 2 
			switch = 8'b0010_1101; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// d + 2
			switch = 8'b0001_1101; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// E + 2
			switch = 8'b0000_1101; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// F + 2
			
			switch = 8'b1111_1100; #10; assert (led === 5'b00011) else $display("Error!"); #10;		// 0 + 3
			switch = 8'b1110_1100; #10; assert (led === 5'b00100) else $display("Error!"); #10;		// 1 + 3
			switch = 8'b1101_1100; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 2 + 3
			switch = 8'b1100_1100; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 3 + 3
			switch = 8'b1011_1100; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 4 + 3
			switch = 8'b1010_1100; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 5 + 3
			switch = 8'b1001_1100; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 6 + 3
			switch = 8'b1000_1100; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 7 + 3
			switch = 8'b0111_1100; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 8 + 3
			switch = 8'b0110_1100; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 9 + 3
			switch = 8'b0101_1100; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// A + 3
			switch = 8'b0100_1100; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// b + 3
			switch = 8'b0011_1100; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// C + 3 
			switch = 8'b0010_1100; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// d + 3
			switch = 8'b0001_1100; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// E + 3
			switch = 8'b0000_1100; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// F + 3
			
			switch = 8'b1111_1011; #10; assert (led === 5'b00100) else $display("Error!"); #10;		// 0 + 4
			switch = 8'b1110_1011; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 1 + 4
			switch = 8'b1101_1011; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 2 + 4
			switch = 8'b1100_1011; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 3 + 4
			switch = 8'b1011_1011; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 4 + 4
			switch = 8'b1010_1011; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 5 + 4
			switch = 8'b1001_1011; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 6 + 4
			switch = 8'b1000_1011; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 7 + 4
			switch = 8'b0111_1011; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 8 + 4
			switch = 8'b0110_1011; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 9 + 4
			switch = 8'b0101_1011; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// A + 4
			switch = 8'b0100_1011; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// b + 4
			switch = 8'b0011_1011; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// C + 4 
			switch = 8'b0010_1011; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// d + 4
			switch = 8'b0001_1011; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// E + 4
			switch = 8'b0000_1011; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// F + 4
			
			switch = 8'b1111_1010; #10; assert (led === 5'b00101) else $display("Error!"); #10;		// 0 + 5
			switch = 8'b1110_1010; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 1 + 5
			switch = 8'b1101_1010; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 2 + 5
			switch = 8'b1100_1010; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 3 + 5
			switch = 8'b1011_1010; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 4 + 5
			switch = 8'b1010_1010; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 5 + 5
			switch = 8'b1001_1010; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 6 + 5
			switch = 8'b1000_1010; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 7 + 5
			switch = 8'b0111_1010; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 8 + 5
			switch = 8'b0110_1010; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 9 + 5
			switch = 8'b0101_1010; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// A + 5
			switch = 8'b0100_1010; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// b + 5
			switch = 8'b0011_1010; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// C + 5 
			switch = 8'b0010_1010; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// d + 5
			switch = 8'b0001_1010; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// E + 5
			switch = 8'b0000_1010; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// F + 5
			
			switch = 8'b1111_1001; #10; assert (led === 5'b00110) else $display("Error!"); #10;		// 0 + 6
			switch = 8'b1110_1001; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 1 + 6
			switch = 8'b1101_1001; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 2 + 6
			switch = 8'b1100_1001; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 3 + 6
			switch = 8'b1011_1001; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 4 + 6
			switch = 8'b1010_1001; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 5 + 6
			switch = 8'b1001_1001; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 6 + 6
			switch = 8'b1000_1001; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 7 + 6
			switch = 8'b0111_1001; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 8 + 6
			switch = 8'b0110_1001; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 9 + 6
			switch = 8'b0101_1001; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// A + 6
			switch = 8'b0100_1001; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// b + 6
			switch = 8'b0011_1001; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// C + 6 
			switch = 8'b0010_1001; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// d + 6
			switch = 8'b0001_1001; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// E + 6
			switch = 8'b0000_1001; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// F + 6
			
			switch = 8'b1111_1000; #10; assert (led === 5'b00111) else $display("Error!"); #10;		// 0 + 7
			switch = 8'b1110_1000; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 1 + 7
			switch = 8'b1101_1000; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 2 + 7
			switch = 8'b1100_1000; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 3 + 7
			switch = 8'b1011_1000; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 4 + 7
			switch = 8'b1010_1000; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 5 + 7
			switch = 8'b1001_1000; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 6 + 7
			switch = 8'b1000_1000; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 7 + 7
			switch = 8'b0111_1000; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 8 + 7
			switch = 8'b0110_1000; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 9 + 7
			switch = 8'b0101_1000; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// A + 7
			switch = 8'b0100_1000; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// b + 7
			switch = 8'b0011_1000; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// C + 7 
			switch = 8'b0010_1000; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// d + 7
			switch = 8'b0001_1000; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// E + 7
			switch = 8'b0000_1000; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// F + 7
			
			switch = 8'b1111_0111; #10; assert (led === 5'b01000) else $display("Error!"); #10;		// 0 + 8
			switch = 8'b1110_0111; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 1 + 8
			switch = 8'b1101_0111; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 2 + 8
			switch = 8'b1100_0111; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 3 + 8
			switch = 8'b1011_0111; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 4 + 8
			switch = 8'b1010_0111; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 5 + 8
			switch = 8'b1001_0111; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 6 + 8
			switch = 8'b1000_0111; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 7 + 8
			switch = 8'b0111_0111; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 8 + 8
			switch = 8'b0110_0111; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 9 + 8
			switch = 8'b0101_0111; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// A + 8
			switch = 8'b0100_0111; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// b + 8
			switch = 8'b0011_0111; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// C + 8 
			switch = 8'b0010_0111; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// d + 8
			switch = 8'b0001_0111; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// E + 8
			switch = 8'b0000_0111; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// F + 8
			
			switch = 8'b1111_0110; #10; assert (led === 5'b01001) else $display("Error!"); #10;		// 0 + 9
			switch = 8'b1110_0110; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 1 + 9
			switch = 8'b1101_0110; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 2 + 9
			switch = 8'b1100_0110; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 3 + 9
			switch = 8'b1011_0110; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 4 + 9
			switch = 8'b1010_0110; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 5 + 9
			switch = 8'b1001_0110; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 6 + 9
			switch = 8'b1000_0110; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 7 + 9
			switch = 8'b0111_0110; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 8 + 9
			switch = 8'b0110_0110; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 9 + 9
			switch = 8'b0101_0110; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// A + 9
			switch = 8'b0100_0110; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// b + 9
			switch = 8'b0011_0110; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// C + 9
			switch = 8'b0010_0110; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// d + 9
			switch = 8'b0001_0110; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// E + 9
			switch = 8'b0000_0110; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// F + 9
			
			switch = 8'b1111_0101; #10; assert (led === 5'b01010) else $display("Error!"); #10;		// 0 + A
			switch = 8'b1110_0101; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 1 + A
			switch = 8'b1101_0101; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 2 + A
			switch = 8'b1100_0101; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 3 + A
			switch = 8'b1011_0101; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 4 + A
			switch = 8'b1010_0101; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 5 + A
			switch = 8'b1001_0101; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 6 + A
			switch = 8'b1000_0101; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 7 + A
			switch = 8'b0111_0101; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 8 + A
			switch = 8'b0110_0101; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 9 + A
			switch = 8'b0101_0101; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// A + A
			switch = 8'b0100_0101; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// b + A
			switch = 8'b0011_0101; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// C + A 
			switch = 8'b0010_0101; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// d + A
			switch = 8'b0001_0101; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// E + A
			switch = 8'b0000_0101; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// F + A
			
			switch = 8'b1111_0100; #10; assert (led === 5'b01011) else $display("Error!"); #10;		// 0 + b
			switch = 8'b1110_0100; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 1 + b
			switch = 8'b1101_0100; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 2 + b
			switch = 8'b1100_0100; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 3 + b
			switch = 8'b1011_0100; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 4 + b
			switch = 8'b1010_0100; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 5 + b
			switch = 8'b1001_0100; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 6 + b
			switch = 8'b1000_0100; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 7 + b
			switch = 8'b0111_0100; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 8 + b
			switch = 8'b0110_0100; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// 9 + b
			switch = 8'b0101_0100; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// A + b
			switch = 8'b0100_0100; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// b + b
			switch = 8'b0011_0100; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// C + b 
			switch = 8'b0010_0100; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// d + b
			switch = 8'b0001_0100; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// E + b
			switch = 8'b0000_0100; #10; assert (led === 5'b11010) else $display("Error!"); #10;		// F + b
			
			switch = 8'b1111_0011; #10; assert (led === 5'b01100) else $display("Error!"); #10;		// 0 + C
			switch = 8'b1110_0011; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 1 + C
			switch = 8'b1101_0011; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 2 + C
			switch = 8'b1100_0011; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 3 + C
			switch = 8'b1011_0011; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 4 + C
			switch = 8'b1010_0011; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 5 + C
			switch = 8'b1001_0011; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 6 + C
			switch = 8'b1000_0011; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 7 + C
			switch = 8'b0111_0011; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// 8 + C
			switch = 8'b0110_0011; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// 9 + C
			switch = 8'b0101_0011; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// A + C
			switch = 8'b0100_0011; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// b + C
			switch = 8'b0011_0011; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// C + C 
			switch = 8'b0010_0011; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// d + C
			switch = 8'b0001_0011; #10; assert (led === 5'b11010) else $display("Error!"); #10;		// E + C
			switch = 8'b0000_0011; #10; assert (led === 5'b11011) else $display("Error!"); #10;		// F + C
			
			switch = 8'b1111_0010; #10; assert (led === 5'b01101) else $display("Error!"); #10;		// 0 + d
			switch = 8'b1110_0010; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 1 + d
			switch = 8'b1101_0010; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 2 + d
			switch = 8'b1100_0010; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 3 + d
			switch = 8'b1011_0010; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 4 + d
			switch = 8'b1010_0010; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 5 + d
			switch = 8'b1001_0010; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 6 + d
			switch = 8'b1000_0010; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// 7 + d
			switch = 8'b0111_0010; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// 8 + d
			switch = 8'b0110_0010; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// 9 + d
			switch = 8'b0101_0010; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// A + d
			switch = 8'b0100_0010; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// b + d
			switch = 8'b0011_0010; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// C + d 
			switch = 8'b0010_0010; #10; assert (led === 5'b11010) else $display("Error!"); #10;		// d + d
			switch = 8'b0001_0010; #10; assert (led === 5'b11011) else $display("Error!"); #10;		// E + d
			switch = 8'b0000_0010; #10; assert (led === 5'b11100) else $display("Error!"); #10;		// F + d
			
			switch = 8'b1111_0001; #10; assert (led === 5'b01110) else $display("Error!"); #10;		// 0 + E
			switch = 8'b1110_0001; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 1 + E
			switch = 8'b1101_0001; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 2 + E
			switch = 8'b1100_0001; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 3 + E
			switch = 8'b1011_0001; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 4 + E
			switch = 8'b1010_0001; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 5 + E
			switch = 8'b1001_0001; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// 6 + E
			switch = 8'b1000_0001; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// 7 + E
			switch = 8'b0111_0001; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// 8 + E
			switch = 8'b0110_0001; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// 9 + E
			switch = 8'b0101_0001; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// A + E
			switch = 8'b0100_0001; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// b + E
			switch = 8'b0011_0001; #10; assert (led === 5'b11010) else $display("Error!"); #10;		// C + E 
			switch = 8'b0010_0001; #10; assert (led === 5'b11011) else $display("Error!"); #10;		// d + E
			switch = 8'b0001_0001; #10; assert (led === 5'b11100) else $display("Error!"); #10;		// E + E
			switch = 8'b0000_0001; #10; assert (led === 5'b11101) else $display("Error!"); #10;		// F + E
			
			switch = 8'b1111_0000; #10; assert (led === 5'b01111) else $display("Error!"); #10;		// 0 + F
			switch = 8'b1110_0000; #10; assert (led === 5'b10000) else $display("Error!"); #10;		// 1 + F
			switch = 8'b1101_0000; #10; assert (led === 5'b10001) else $display("Error!"); #10;		// 2 + F
			switch = 8'b1100_0000; #10; assert (led === 5'b10010) else $display("Error!"); #10;		// 3 + F
			switch = 8'b1011_0000; #10; assert (led === 5'b10011) else $display("Error!"); #10;		// 4 + F
			switch = 8'b1010_0000; #10; assert (led === 5'b10100) else $display("Error!"); #10;		// 5 + F
			switch = 8'b1001_0000; #10; assert (led === 5'b10101) else $display("Error!"); #10;		// 6 + F
			switch = 8'b1000_0000; #10; assert (led === 5'b10110) else $display("Error!"); #10;		// 7 + F
			switch = 8'b0111_0000; #10; assert (led === 5'b10111) else $display("Error!"); #10;		// 8 + F
			switch = 8'b0110_0000; #10; assert (led === 5'b11000) else $display("Error!"); #10;		// 9 + F
			switch = 8'b0101_0000; #10; assert (led === 5'b11001) else $display("Error!"); #10;		// A + F
			switch = 8'b0100_0000; #10; assert (led === 5'b11010) else $display("Error!"); #10;		// b + F
			switch = 8'b0011_0000; #10; assert (led === 5'b11011) else $display("Error!"); #10;		// C + F 
			switch = 8'b0010_0000; #10; assert (led === 5'b11100) else $display("Error!"); #10;		// d + F
			switch = 8'b0001_0000; #10; assert (led === 5'b11101) else $display("Error!"); #10;		// E + F
			switch = 8'b0000_0000; #10; assert (led === 5'b11110) else $display("Error!"); #10;		// F + F
		end
	
endmodule    