/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 12, 2025

Purpose: To assign hexadecimal digits (ranging from 0x0 to 0xF) to specific keys on the 4x4 keypad (type 2).
*/

module key_to_digit_converter_2(input logic  [7:0] key,
								output logic [3:0] digit);
	
	// keypad location decoder
	always_comb
		case(key)
			// (row_column)			 (digit)
			// 3210_3210
			8'b0001_0010: digit = 4'b0000;		// 0
			8'b1000_0001: digit = 4'b0001;		// 1
			8'b1000_0010: digit = 4'b0010;		// 2
			8'b1000_0100: digit = 4'b0011;		// 3
			8'b0100_0001: digit = 4'b0100;		// 4
			8'b0100_0010: digit = 4'b0101;		// 5
			8'b0100_0100: digit = 4'b0110;		// 6
			8'b0010_0001: digit = 4'b0111;		// 7
			8'b0010_0010: digit = 4'b1000;		// 8
			8'b0010_0100: digit = 4'b1001;		// 9
			8'b0001_0001: digit = 4'b1010;		// A
			8'b0001_0100: digit = 4'b1011;		// B
			8'b1000_1000: digit = 4'b1100;		// C
			8'b0100_1000: digit = 4'b1101;		// D
			8'b0010_1000: digit = 4'b1110;		// E
			8'b0001_1000: digit = 4'b1111;		// F
			default:      digit = 4'b0000;
		endcase
	
endmodule