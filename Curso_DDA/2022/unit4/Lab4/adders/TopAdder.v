`timescale 1ns / 1ps

// Puertos definidos en xdc
// i_sampleA[15:0]
// i_sambleB[15:0]
// o_sum[16:0]
// i_carry
// clock

`define ADDER_BCLA
//`define ADDER_HCSA
//`define ADDER_RCA

module topAdder
  #(parameter N = 16)
  (
    input      [N-1:0] i_sampleA,i_sampleB,
    input              i_carry,
    input              clock,
    output reg [N:0]   o_sum
  );
  wire [N-1:0] sum_r;
  wire         c_out_r;
  
always@(posedge clock) begin
  o_sum   <= {c_out_r, sum_r};
end

`ifdef ADDER_BCLA
    // Modulo BCLA (N = 16)
    // input      [N-1:0] a,b,
    // input              c_in,
    // input              clk,
    // output reg [N-1:0] sum_r,
    // output reg         c_out_r
    bcla u_bcla(
                .a(i_sampleA[15:0]),
                .b(i_sampleB[15:0]),
                .c_in(i_carry),
                .clk(clock),
                .sum_r(sum_r[15:0]),
                .c_out_r(c_out_r)
                );
`elsif ADDER_HCSA
    // Modulo HCSA
    // a, b, cin, sum_r, c_out_r, clk
    hcsa u_hcsa();
`else
    // Modulo RCA
    // input              clk,
    // input [W-1:0]      a, b,
    // input              cin,
    // output reg [W-1:0] s_r,
    // output reg         cout_r
    rca u_rca();
`endif

endmodule
