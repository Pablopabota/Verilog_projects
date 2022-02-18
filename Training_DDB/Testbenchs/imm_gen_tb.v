`timescale 100ns/10ns
`include "../MEM/flip-flops.v"

`define ADDRESS_SIZE 32
`define WORD_SIZE 32
`define READ_REG_SIZE 5
`define WRITE_REG_SIZE 5

module imm_gen_tb;

    // Entradas
    reg [`WORD_SIZE-1:0] inst_tb;
    
    // Salidas
    wire [(2*`WORD_SIZE)-1:0] imm_gen_tb;
    
    //imm[31:12] rd 0110111 LUI
    `define INST_LUI { $random(897), 7'b0110111}
    
    //imm[20|10:1|11|19:12] rd 1101111 JAL
    `define INST_JAL { $random(897), 7'b1101111}
    
    //imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 BEQ
    `define INST_BEQ { $random(897), 7'b1100011}
    
    //imm[11:5] rs2 rs1 000 imm[4:0] 0100011 SB
    `define INST_SB { $random(897), 7'b0100011}
    
    //imm[11:0] rs1 000 rd 1100111 JALR
    `define INST_JALR { $random(897), 7'b1100111}
    
    imm_gen #() imm_gen_uut (
            .i_inst(inst_tb),
            .o_imm_gen(imm_gen_tb)
        );
    
    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(2, imm_gen_tb);

        // Inicializo el sistema
        
        // Inicializo entradas
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        inst_tb = `INST_LUI;
        $display("LUI: %X | LUI[6:0]: %X | result: %X", inst_tb, inst_tb[6:0],  inst_tb[31:12]);
        #1
        inst_tb = `INST_JAL;
        $display("JAL: %X | JAL[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31], inst_tb[19:12], inst_tb[20], inst_tb[30:21], 1'b0});
        #1
        inst_tb = `INST_BEQ;
        $display("BEQ: %X | BEQ[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], { inst_tb[31], inst_tb[7], inst_tb[30:25], inst_tb[11:8], 1'b0 } );
        #1
        inst_tb = `INST_SB;
        $display("SB: %X | SB[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31:25], inst_tb[11:7]});
        #1
        inst_tb = `INST_JALR;
        $display("JALR: %X | JALR[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], inst_tb[31:20]);
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        inst_tb = `INST_LUI;
        $display("LUI: %X | LUI[6:0]: %X | result: %X", inst_tb, inst_tb[6:0],  inst_tb[31:12]);
        #1
        inst_tb = `INST_JAL;
        $display("JAL: %X | JAL[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31], inst_tb[19:12], inst_tb[20], inst_tb[30:21], 1'b0});
        #1
        inst_tb = `INST_BEQ;
        $display("BEQ: %X | BEQ[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], { inst_tb[31], inst_tb[7], inst_tb[30:25], inst_tb[11:8], 1'b0 } );
        #1
        inst_tb = `INST_SB;
        $display("SB: %X | SB[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31:25], inst_tb[11:7]});
        #1
        inst_tb = `INST_JALR;
        $display("JALR: %X | JALR[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], inst_tb[31:20]);
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        inst_tb = `INST_LUI;
        $display("LUI: %X | LUI[6:0]: %X | result: %X", inst_tb, inst_tb[6:0],  inst_tb[31:12]);
        #1
        inst_tb = `INST_JAL;
        $display("JAL: %X | JAL[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31], inst_tb[19:12], inst_tb[20], inst_tb[30:21], 1'b0});
        #1
        inst_tb = `INST_BEQ;
        $display("BEQ: %X | BEQ[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], { inst_tb[31], inst_tb[7], inst_tb[30:25], inst_tb[11:8], 1'b0 } );
        #1
        inst_tb = `INST_SB;
        $display("SB: %X | SB[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31:25], inst_tb[11:7]});
        #1
        inst_tb = `INST_JALR;
        $display("JALR: %X | JALR[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], inst_tb[31:20]);
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        inst_tb = `INST_LUI;
        $display("LUI: %X | LUI[6:0]: %X | result: %X", inst_tb, inst_tb[6:0],  inst_tb[31:12]);
        #1
        inst_tb = `INST_JAL;
        $display("JAL: %X | JAL[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31], inst_tb[19:12], inst_tb[20], inst_tb[30:21], 1'b0});
        #1
        inst_tb = `INST_BEQ;
        $display("BEQ: %X | BEQ[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], { inst_tb[31], inst_tb[7], inst_tb[30:25], inst_tb[11:8], 1'b0 } );
        #1
        inst_tb = `INST_SB;
        $display("SB: %X | SB[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31:25], inst_tb[11:7]});
        #1
        inst_tb = `INST_JALR;
        $display("JALR: %X | JALR[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], inst_tb[31:20]);
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        inst_tb = `INST_LUI;
        $display("LUI: %X | LUI[6:0]: %X | result: %X", inst_tb, inst_tb[6:0],  inst_tb[31:12]);
        #1
        inst_tb = `INST_JAL;
        $display("JAL: %X | JAL[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31], inst_tb[19:12], inst_tb[20], inst_tb[30:21], 1'b0});
        #1
        inst_tb = `INST_BEQ;
        $display("BEQ: %X | BEQ[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], { inst_tb[31], inst_tb[7], inst_tb[30:25], inst_tb[11:8], 1'b0 } );
        #1
        inst_tb = `INST_SB;
        $display("SB: %X | SB[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], {inst_tb[31:25], inst_tb[11:7]});
        #1
        inst_tb = `INST_JALR;
        $display("JALR: %X | JALR[6:0]: %X | result: %X", inst_tb, inst_tb[6:0], inst_tb[31:20]);
        //////////////////////////////////////////////////////////////////////////////////////////////
        #1
        $finish;
        
        // Inicializo UUT
    end
    
    
endmodule