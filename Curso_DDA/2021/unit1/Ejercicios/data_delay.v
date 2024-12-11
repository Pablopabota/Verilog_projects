`include "d_ff.v"

module data_delay #(
    parameter BITS = 8,
    parameter DELAY = 4
) (
    input [BITS-1:0]    i_Din,
    input               i_clk,
    input               i_rst,
    output reg [(DELAY*BITS)-1 : 0]    o_Dout
);

    wire [BITS-1:0] C [DELAY:0];

    genvar index;
    assign C[0] = i_Din;
    generate
        for (index = 0; index < DELAY; index = index + 1) begin:delay
            d_ff #(
                .BITS(BITS),
                .DEBUG(index)
            ) d_ff (
                .i_Din(C[index]),
                .i_clk(i_clk),
                .i_rst(i_rst),
                .o_Dout(C[index+1])
            );
            always @(*) begin
                o_Dout[((index+1)*BITS)-1:(index*BITS)] <= C[index+1];
            end
        end
    endgenerate

endmodule