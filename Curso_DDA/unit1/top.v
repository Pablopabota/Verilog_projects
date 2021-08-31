module top (
    output [3:0] o_led,
    output [3:0] o_led_b,
    output [3:0] o_led_g,
    input [3:0] i_sw,
    input i_reset,
    input clock,
);
    counter u_counter(
        .o_valid(),
        .i_sw(i_sw[2:0]),
        .i_reset(i_reset),
        .clock(clock)
        );

    shiftreg u_shiftreg (
        .o_led(),
        .i_valid(),
        .i_reset(i_reset),
        .clock(clock)
    );
endmodule 