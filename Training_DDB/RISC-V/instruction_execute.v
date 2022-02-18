`include "../ALU/alu.v"

`include "../MUX/mux.v"

`include "../SUM/adder.v"

`define WORD_SIZE 32

`define REG_RD_1_INIT 15
`define REG_RD_2_INIT 20
`define REG_RD_SIZE 5
`define RD_DATA_SIZE `WORD_SIZE
`define IMM_GEN_SIZE 2*`WORD_SIZE

`define REG_WR_INIT 7
`define REG_WR_SIZE 5

`define PC_SIZE 2*`WORD_SIZE
`define INS_MEM_SIZE `WORD_SIZE

module inst_exe (
    input i_id_ex_reg,
    output reg o_ex_mem_reg
);

    wire [`PC_SIZE-1:0] ex_sum_b;
    wire [`PC_SIZE-1:0] pc_ex_a;
    wire [`PC_SIZE-1:0] mux_ex_o;

    assign ex_sum_b = i_id_ex_reg[69:5]<<1;
    assign pc_ex_a = i_id_ex_reg[195:133];
        
    mux21_nbits #(
        .BITS(`PC_SIZE)
        ) mux_ex (
            .os(),
            .data_0(),
            .data_1(),
            .data_out()
    );
        
    adder_nbits #(
        .BITS(`PC_SIZE)
        ) adder_ex (
            .i_data_a(pc_ex_a), 
            .i_data_b(ex_sum_b),
            .o_data_out(mux_ex_o)
    );
endmodule