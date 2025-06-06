`timescale 100ns/1ns
`include "../RISC-V/risc-v.v"

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

module risc_v_tb ();
    
    // Entradas
    reg rst_tb;
    reg clk_tb;
    // Salidas
    wire [`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:0] id_ex_reg_tb;

    risc_v uut (
    .i_rst(rst_tb),
    .i_clk(clk_tb),
    .id_ex_reg_top(id_ex_reg_tb)
    );

    initial begin
        rst_tb = 1'b0;
        clk_tb = 1'b0;
    end

    always #1 clk_tb = !clk_tb;

    always @(posedge clk_tb) begin
        if ($time > 5)begin
            rst_tb = 1'b1;
        end

//        if ($time > 100)begin
//            $finish;
//        end
    end


endmodule