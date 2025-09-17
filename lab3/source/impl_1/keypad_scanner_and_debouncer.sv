/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 12, 2025

Purpose: To both scan the keypad for keys being pressed and subsequently debounce them, such that the output comprises the (stabilized) locations of the two most recently pressed keys;
		 more specifically, to provide a complex FSM (along with a necessary state-toggling flip-flop) in order to accomplish the aforementioned tasks.
*/

module keypad_scanner_and_debouncer(input logic        internal_oscillator,
									 input logic        reset,
									 input logic  [3:0] keypad_column,
									 output logic [3:0] keypad_row,
									 output logic [7:0] most_recent_key,
									 output logic [7:0] second_most_recent_key);
			
	typedef enum logic [3:0] {SCAN_ROW_0, SCAN_ROW_1, SCAN_ROW_2, SCAN_ROW_3, DEBOUNCE_PRESS, DECODE_KEY, DEBOUNCE_RELEASE} statetype;
	statetype state, next_state;
	
	logic [23:0] counter, next_counter;
	
	logic [3:0] actual_toggled_row, next_actual_toggled_row;
	logic [3:0] next_toggled_row;
	logic [3:0] toggled_column, next_toggled_column;
	logic [3:0] stabilized_column;
	
	logic [7:0] debounced_key, last_debounced_key;
	
	// toggles through each state at the rising edge of every clock cycle
	// assigns each output and intermediate variable new values, depending on the specifications of the current state
	always_ff @(posedge internal_oscillator, negedge reset)
		begin
			// passes default values when reset is enabled
			// starts the FSM in its first state, SCAN_ROW_0, and supplies Row 0 with power accordingly
			if (~reset)
				begin
					keypad_row <= 4'b0001;
					actual_toggled_row <= 4'b0;
					
					toggled_column <= 4'b0;
					
					most_recent_key <= 8'b0;
					second_most_recent_key <= 8'b0;

					counter <= 24'b0;
					state <= SCAN_ROW_0;
				end
				
			// passes state-dependent values otherwise
			// transitions between states and preserves old output values as necessary
			else
				begin
					keypad_row <= next_toggled_row;					// interfaces with the FPGA pins to assert which row(s) should be active
					actual_toggled_row <= next_actual_toggled_row;		// accounts for the two-cycle offset that the below synchronizer causes as it pertains to the actual row active during a given state
					
					toggled_column <= next_toggled_column;				// preserves the response of the columns to the rows toggling on and off
					
					most_recent_key <= debounced_key;					// maintains the value of the most recently pressed key
					second_most_recent_key <= last_debounced_key;		// maintains the value of the second most recently pressed key
					
					counter <= next_counter;							// keeps track of the number of clock cycles that passed
					state <= next_state;								// switches FSM states
				end
		end
	
	// synchronizes the asynchronous keypad column inputs to prevent metastability
	keypad_column_synchronizer key_column_sync(internal_oscillator, reset, keypad_column, stabilized_column);
	
	// FSM for scanning, debouncing, and decoding
	always_comb
		case(state)
			// applies power to Row 0 and sees if any columns activate in response
			SCAN_ROW_0:
						begin
							// sets Row 0 as the next toggled row if any column goes high; sets Row 1 otherwise
							// takes Row 2 to be the actual toggled row after accounting for delay
							next_toggled_row = ((|stabilized_column) ? 4'b0001 : 4'b0010);
							next_actual_toggled_row = 4'b0100;
							
							// sets the synchronized column as the next one to be toggled
							next_toggled_column = stabilized_column;
							
							// retains the last most recent (and second most recent) key values
							debounced_key = most_recent_key;
							last_debounced_key = second_most_recent_key;
							
							// if any column goes high, goes to debounce; otherwise, proceeds to scan the next row
							next_counter = 24'b0;
							next_state = ((|stabilized_column) ? DEBOUNCE_PRESS : SCAN_ROW_1);
						end
			
			// applies power to Row 1 and sees if any columns activate in response
			SCAN_ROW_1:
						begin
							// sets Row 1 as the next toggled row if any column goes high; sets Row 2 otherwise
							// takes Row 3 to be the actual toggled row after accounting for delay
							next_toggled_row = ((|stabilized_column) ? 4'b0010 : 4'b0100);
							next_actual_toggled_row = 4'b1000;
							
							// sets the synchronized column as the next one to be toggled
							next_toggled_column = stabilized_column;
							
							// retains the last most recent (and second most recent) key values
							debounced_key = most_recent_key;
							last_debounced_key = second_most_recent_key;
							
							// if any column goes high, goes to debounce; otherwise, proceeds to scan the next row
							next_counter = counter;
							next_state = ((|stabilized_column) ? DEBOUNCE_PRESS : SCAN_ROW_2);
						end

			// applies power to Row 2 and sees if any columns activate in response
			SCAN_ROW_2:
						begin
							// sets Row 2 as the next toggled row if any column goes high; sets Row 3 otherwise
							// takes Row 0 to be the actual toggled row after accounting for delay
							next_toggled_row = ((|stabilized_column) ? 4'b0100 : 4'b1000);
							next_actual_toggled_row = 4'b0001;
							
							// sets the synchronized column as the next one to be toggled
							next_toggled_column = stabilized_column;
							
							// retains the last most recent (and second most recent) key values
							debounced_key = most_recent_key;
							last_debounced_key = second_most_recent_key;
							
							// if any column goes high, goes to debounce; otherwise, proceeds to scan the next row
							next_counter = counter;
							next_state = ((|stabilized_column) ? DEBOUNCE_PRESS : SCAN_ROW_3);
						end
						
			// applies power to Row 3 and sees if any columns activate in response
			SCAN_ROW_3:
						begin
							// sets Row 3 as the next toggled row if any column goes high; sets Row 0 otherwise
							// takes Row 1 to be the actual toggled row after accounting for delay
							next_toggled_row = ((|stabilized_column) ? 4'b1000 : 4'b0001);
							next_actual_toggled_row = 4'b0010;
							
							// sets the synchronized column as the next one to be toggled
							next_toggled_column = stabilized_column;
							
							// retains the last most recent (and second most recent) key values
							debounced_key = most_recent_key;
							last_debounced_key = second_most_recent_key;
							
							// if any column goes high, goes to debounce; otherwise, proceeds to scan the next row
							next_counter = counter;
							next_state = ((|stabilized_column) ? DEBOUNCE_PRESS : SCAN_ROW_0);
						end
						
			// switch-debounces the button press
			DEBOUNCE_PRESS:
						begin
							// maintains the value of the actual, offset row of the key that was initially pressed
							next_toggled_row = next_actual_toggled_row;
							next_actual_toggled_row = actual_toggled_row;

							// maintains the value of the synchronized column of the key that was initially pressed
							next_toggled_column = toggled_column;
							
							// shifts the value of the last most recent key to the second most recent key
							debounced_key = most_recent_key;
							last_debounced_key = most_recent_key;
							
							// waits 0.1 s for the bouncing to stop (i.e. for the signal to settle)
							next_counter = counter + 24'd1;
							next_state = ((counter < 24'd1200000) ? DEBOUNCE_PRESS : DECODE_KEY);
						end
				
			// assigns the most recent and second most recent key locations to the module outputs
			DECODE_KEY:
						begin
							// maintains the value of the actual, offset row of the key that was initially pressed
							next_toggled_row = actual_toggled_row;
							next_actual_toggled_row = actual_toggled_row;
							
							// maintains the value of the synchronized column of the key that was initially pressed
							next_toggled_column = toggled_column;
							
							// sets the most recent key according to the preserved row and column values
							debounced_key = {actual_toggled_row, toggled_column};
							last_debounced_key = second_most_recent_key;
							
							// transitions out of the decoding stage once no more columns are activated (i.e. no more keys are pressed)
							next_counter = 24'b0;
							next_state = ((|(stabilized_column & toggled_column)) ? DECODE_KEY : DEBOUNCE_RELEASE);
						end
						
			// switch-debounces the button release
			DEBOUNCE_RELEASE:
						begin
							// turns off all rows
							next_toggled_row = 4'b0;
							next_actual_toggled_row = 4'b0;

							// resets the active columns so as to not falsely trigger any button presses once restarting the cycle
							next_toggled_column = 4'b0;
							
							// retains the last most recent (and second most recent) key values
							debounced_key = most_recent_key;
							last_debounced_key = second_most_recent_key;
							
							// waits 0.1 s for the bouncing to stop (i.e. for the signal to settle)
							next_counter = counter + 24'd1;
							next_state = ((counter < 24'd1200000) ? DEBOUNCE_RELEASE : SCAN_ROW_0);
						end

			// sets a default state and values
			default:
						begin
							next_toggled_row = keypad_row;
							next_actual_toggled_row = actual_toggled_row;
							
							next_toggled_column = 4'b0;
							
							debounced_key = 8'b0;
							last_debounced_key = second_most_recent_key;
							
							next_counter = 24'b0;
							next_state = SCAN_ROW_0;
						end
		endcase
				
endmodule