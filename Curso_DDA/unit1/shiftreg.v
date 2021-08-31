module shiftreg #(
    NB_LEDS = 4
)(
    output [NB_LEDS-1:0] o_led,
    input i_valid,
    input i_reset,
    input clock
);
    reg [NB_LEDS-1:0] shiftreg;
    
endmodule