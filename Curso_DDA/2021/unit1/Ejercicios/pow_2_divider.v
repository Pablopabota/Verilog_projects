module pow_2_divider #(
    parameter BITS = 8,
    parameter DIVIDE = 4
)(
    input      [BITS-1:0]   i_Din,
    input                   i_clk,
    output reg [BITS-1:0]   o_Dout
);

always @(posedge i_clk) begin
    // o_Dout = { { $clog2(DIVIDE){1'b0} } , i_Din[BITS-1:$clog2(DIVIDE)] };
    $display("time: %4d | Din: %4b (%4d) | Dout: %4b (%4d) | pre-divider", $time, i_Din, i_Din, o_Dout, o_Dout);  // Para FPGA
    o_Dout = i_Din>>$clog2(DIVIDE);
    $display("time: %4d | Din: %4b (%4d) | Dout: %4b (%4d) | post-divider", $time, i_Din, i_Din, o_Dout, o_Dout);  // Para FPGA
end

endmodule