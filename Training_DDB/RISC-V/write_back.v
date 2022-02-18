`include "../MUX/mux.v"

`define WORD_SIZE 32
`define REG_WR_SIZE 5

module wb_module (
    input                           i_os,
    input                           i_mem_wb_reg,
    output reg  [`WORD_SIZE-1:0]    o_data_out,
    output reg  [`REG_WR_SIZE-1:0]  o_wr_reg
);
    
    mux21_nbits #(
        .BITS(`WORD_SIZE)
        ) mux_wb (
            .os(i_os),
            .data_0(i_data_0),
            .data_1(i_data_1),
            .data_out(o_data_out)
    );

endmodule