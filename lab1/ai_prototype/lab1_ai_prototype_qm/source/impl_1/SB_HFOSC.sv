`ifndef SYNTHESIS
module SB_HFOSC #(parameter CLKHF_DIV = "0b00") (
    input  logic CLKHFEN,
    input  logic CLKHFPU,
    output logic CLKHF
);
    // Behavioral oscillator model for sim only
    parameter real PERIOD_NS = 83.333; // ~12 MHz
    initial CLKHF = 0;
    always #(PERIOD_NS/2.0) CLKHF = ~CLKHF;
endmodule
`endif

//`ifndef SYNTHESIS
//module SB_HFOSC #(parameter CLKHF_DIV = "0b00") (
    //input  logic CLKHFEN,
    //input  logic CLKHFPU,
    //output logic CLKHF
//);
    //Simple behavioral model for simulation
    //Assume 12 MHz (divide by 4 mode)
    //parameter real PERIOD_NS = 83.333; // 12 MHz
    //initial CLKHF = 0;
    //always #(PERIOD_NS/2.0) CLKHF = ~CLKHF;
//endmodule
//`endif
