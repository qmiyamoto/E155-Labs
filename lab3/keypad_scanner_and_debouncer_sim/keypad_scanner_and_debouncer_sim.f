-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/lab3_qm.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/seven_segment_display.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/seven_segment_display_multiplexer.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/manual_clock_divider.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/key_to_digit_converter_1.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/key_to_digit_converter_2.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/keypad_column_synchronizer.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/keypad_scanner_and_debouncer.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab3/lab3_qm/source/impl_1/keypad_scanner_and_debouncer_testbench.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top testbench
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run 100 ns"
