/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  August 27, 2025

Purpose: To replicate hexadecimal digits 0 through F with the seven-segment display, depending on the positions of the SW6 DIP switches.
*/

module seven_segment_display(input logic  [3:0] s,
						     output logic [6:0] seg);

	// seven-segment display decoder
	always_comb
		case(s)
			// (switches)     (segments)
			// 4321           GFEDCBA
			4'b1111: seg = 7'b1000000;		// 0
			4'b1110: seg = 7'b1111001;		// 1
			4'b1101: seg = 7'b0100100;		// 2
			4'b1100: seg = 7'b0110000;		// 3
			4'b1011: seg = 7'b0011001;		// 4
			4'b1010: seg = 7'b0010010;		// 5
			4'b1001: seg = 7'b0000010;		// 6
			4'b1000: seg = 7'b1111000;		// 7
			4'b0111: seg = 7'b0000000;		// 8
			4'b0110: seg = 7'b0011000;		// 9
			4'b0101: seg = 7'b0001000;		// A
			4'b0100: seg = 7'b0000011;		// b
			4'b0011: seg = 7'b1000110;		// C
			4'b0010: seg = 7'b0100001;		// d
			4'b0001: seg = 7'b0000110;		// E
			4'b0000: seg = 7'b0001110;		// F
			default: seg = 7'b1111111;
		endcase

endmodule