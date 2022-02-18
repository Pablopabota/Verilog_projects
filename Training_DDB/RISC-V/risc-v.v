`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "instruction_execute.v"
`include "data_memory.v"

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

module risc_v (
    input i_rst,
    input i_clk,
    output reg [`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:0] id_ex_reg_top
);
// Definicion de pipeline registers
    reg [`PC_SIZE+`INS_MEM_SIZE-1:0] if_id_reg_top;
//    reg [`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:0] id_ex_reg_top;
    reg [1:0] ex_mem_reg;
    reg [1:0] mem_wb_reg;

// MEMORY

// WRITE BACK
    wire [(2*`WORD_SIZE)+`REG_WR_SIZE-1:0] wb_bus;
    wire [`WORD_SIZE-1:0] mux_wb_out;

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
// INSTRUCTION FETCH SIDE
    inst_fetch #() instruction_fetch_module (
        .i_mem_pc(ex_mem_reg[]),
        .i_ctrl_mux_if(1'b0),           // Esto lo maneja el block de CONTROL
        .o_if_id_reg(if_id_reg_top)
    );
// END INSTRUCTION FETCH SIDE
///////////////////////////////////////////////////////////////////////////////////
// INSTRUCTION DECODE
    inst_dec #() instruction_decode_module (
        .i_if_id_reg(if_id_reg_top),
        .i_wr_reg(0),                   // Esto es realimentacion de un pipe en WRITE_BACK
        .i_wr_data(),                   // Aca va la salida del MUX de WRITE_BACK
        .i_reg_wr(1'b0),                // Esto lo maneja el block de CONTROL
        .o_id_ex_reg(id_ex_reg_top)
    );
// END INSTRUCTION DECODE
///////////////////////////////////////////////////////////////////////////////////
// EXECUTE
    inst_exe #() instruction_execute_module (
        .i_id_ex_reg(),
        .o_ex_mem_reg()
    );
// END EXECUTE
///////////////////////////////////////////////////////////////////////////////////
// MEMORY
    data_mem #() data_memory_module (
        .i_ex_mem_reg(),
        .o_mem_pc(),
        .o_mem_wb_reg()
    );
// END MEMORY
///////////////////////////////////////////////////////////////////////////////////
// WRITE BACK
    wb_module #() write_back_module (
        .i_os(),
        .i_mem_wb_reg(),
        .o_data_out(),
        .o_wr_reg()
    );
// END WRITE BACK
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
endmodule