-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/peppe/OneDrive/Desktop/lab2/source/impl_1/lab2_qm.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab2/source/impl_1/seven_segment_display.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab2/source/impl_1/leds_sum.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab2/source/impl_1/time_multiplexer.sv" 
"C:/Users/peppe/OneDrive/Desktop/lab2/source/impl_1/lab2_qm_testbench.sv" 
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
