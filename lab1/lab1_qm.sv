/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  August 27, 2025

Purpose: To interface the SW6 DIP switches with both the on-board LEDs and seven-segment display.
*/

module lab1_qm(input logic        clk,
			   input logic        reset,
			   input logic  [3:0] s,
			   output logic [2:0] led,
			   output logic [6:0] seg);
			   
	// toggles the on-board LEDs
	on_board_leds leds(clk, reset, s, led);
			   
	// sets the seven-segment display
	seven_segment_display sev_seg(s, seg);
			   
endmodule
