-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/peppe/OneDrive/Desktop/Fall 2025 - Spring 2026/ENGR 155/e155-labs/lab1/lab1_qm.sv" 
"C:/Users/peppe/OneDrive/Desktop/Fall 2025 - Spring 2026/ENGR 155/e155-labs/lab1/source/impl_1/seven_segment_display.sv" 
"C:/Users/peppe/OneDrive/Desktop/Fall 2025 - Spring 2026/ENGR 155/e155-labs/lab1/source/impl_1/on_board_leds.sv" 
"C:/Users/peppe/OneDrive/Desktop/Fall 2025 - Spring 2026/ENGR 155/e155-labs/lab1/source/impl_1/seven_segment_display_testbench.sv" 
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
