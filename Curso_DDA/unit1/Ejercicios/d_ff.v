module d_ff #(
    parameter BITS = 8
)(
    input      [BITS-1:0]   i_Din,
    input                   i_clk,
    input                   i_rst,
    output reg [BITS-1:0]   o_Dout
);

always @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        o_Dout <= { BITS{1'b0} };
    end
    else begin
        o_Dout <= i_Din;
    end
end

endmodule