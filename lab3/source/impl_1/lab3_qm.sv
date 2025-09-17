/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 12, 2025

Purpose: To interface the FPGA with a 4x4 keypad, two transistors, and two 7-segment displays.
*/

module lab3_qm(input logic        reset,
			   input logic  [3:0] keypad_column,
			   output logic [3:0] keypad_row,
			   output logic [1:0] transistor,
			   output logic [6:0] segment);
	
	logic internal_oscillator;
	
	logic [7:0] most_recent_key, second_most_recent_key;
	
	logic [3:0] most_recent_digit;
	logic [3:0] second_most_recent_digit;
	
	// internal high-speed oscillator
	HSOSC #(.CLKHF_DIV(2'b00)) 
    hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(internal_oscillator));
	
	// manually divides the internal oscillator to convert the default 48 MHz signal to a 24 MHz one
	manual_clock_divider clock_div(internal_oscillator, reset, halved_internal_oscillator);
	
	// scans for pressed keys and subsequently debounces them
	// stores the locations (in the 4x4 matrix) of the two most recently pressed keys
	keypad_scanner_and_debouncer key_scan_debounce(halved_internal_oscillator, reset, keypad_column, keypad_row, most_recent_key, second_most_recent_key);
	
	// converts the key locations to the actual digits corresponding to them
	key_to_digit_converter_1 key_digi_conv_1_1(most_recent_key, most_recent_digit);
	key_to_digit_converter_1 key_digi_conv_1_2(second_most_recent_key, second_most_recent_digit);
	// key_to_digit_converter_2 key_digi_conv_2_1(most_recent_key, most_recent_digit);
	// key_to_digit_converter_2 key_digi_conv_2_2(second_most_recent_key, second_most_recent_digit);
	
	// toggles the transistors driving current to the 7-segment displays
	seven_segment_display_multiplexer sev_seg_mux(halved_internal_oscillator, reset, transistor);

	// multiplexes the activation of the 7-segment displays
	// sets the 7-segment display digits to the two most recent digits accordingly
	seven_segment_display sev_seg((transistor[0] ? ~most_recent_digit : ~second_most_recent_digit), segment);
	
endmodule