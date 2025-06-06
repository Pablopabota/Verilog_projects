`include "mux4.v"
`include "register_bank.v"

module mux4_registered #(
    parameter WIDTH = 8
    ) (
    input [0:0]     clk,
    input [0:0]     rst,
    input [1:0]     sel,
    input [0:0]     wr_en,
    input [WIDTH-1:0] in1, in2, in3, in4,
    output [WIDTH-1:0] out
);

    wire mux_to_bank;

    mux4 #(.WIDTH(WIDTH)) mux (
    .din1(in1),
    .din2(in2),
    .din3(in3),
    .din4(in4),
    .select(sel),
    .dout(mux_to_bank)
    );

    register_bank #(.WIDTH(WIDTH)) bank (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .in(mux_to_bank),
    .out(out)
    );

endmodule
