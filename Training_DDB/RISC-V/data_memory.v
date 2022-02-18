`include "../MEM/memory.v"

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

module data_mem (
    input i_ex_mem_reg,
    output reg o_mem_pc,
    output reg o_mem_wb_reg
);
    
endmodule