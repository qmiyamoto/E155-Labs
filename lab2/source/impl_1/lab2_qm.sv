	`/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 5, 2025

Purpose: To interface the FPGA's internal oscillator with transistors, LEDs, DIP switches, and two 7-segment displays.
*/

module lab2_qm(input logic         reset,
			   input logic  [7:0]  switch,
			   output logic [6:0]  segment,
			   output logic [4:0]  led,
			   output logic [1:0]  transistor);
			   
	// internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(internal_oscillator));
	
	// toggles the transistors
	time_multiplexer time_mux(internal_oscillator, reset, transistor);
	
	// multiplexes the activation of the 7-segment displays
	// sets the 7-segment display digits according to switch positions
	seven_segment_display sev_seg((transistor[0] ? switch[3:0] : switch[7:4]), segment);
	
	// outputs the sum of the two digits being displayed across five LEDs
	leds_sum sum(switch, led);
			   
endmodule