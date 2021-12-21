module d_ff #(
    parameter BITS = 8,
    parameter DEBUG = 0
)(
    input      [BITS-1:0]   i_Din,
    input                   i_clk,
    input                   i_rst,
    output reg [BITS-1:0]   o_Dout
);

always @(posedge i_clk or negedge i_rst) begin
    $display("Flop %4d | i_Din %4d | o_Dout %4d | i_rst %4d", DEBUG, i_Din, o_Dout, i_rst);
    if (!i_rst) begin
        // $display("reinicio flop %2d", DEBUG);
        o_Dout <= { BITS{1'b0} };
    end
    else begin
        // $display("Flop %2d: input %2d -> output %2d", DEBUG, i_Din, o_Dout);
        o_Dout <= i_Din;
    end
end

endmodule