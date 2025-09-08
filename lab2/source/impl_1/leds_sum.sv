/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 5, 2025

Purpose: To display the results of addition between two hexadecimal numbers in binary across five LEDs.
	     (Note that the values of said hexadecimal numbers are dependent on the positions of eight individual slide-switches.)
*/

module leds_sum(input logic  [7:0] switch,
				output logic [4:0] led);
	
	assign led = (~switch[3:0] + ~switch[7:4]);
	
endmodule