// Estas operaciones son de tipo R, por lo que no tienen inmediato
// parameter SLLI = 0010011;
// parameter SRLI = 0010011;
// parameter SRAI = 0010011;
// parameter ADD = 0110011;
// parameter SUB = 0110011;
// parameter SLL = 0110011;
// parameter SLT = 0110011;
// parameter SLTU = 0110011;
// parameter XOR = 0110011;
// parameter SRL = 0110011;
// parameter SRA = 0110011;
// parameter OR = 0110011;
// parameter AND = 0110011;

`define LUI 7'b0110111
`define AUIPC 7'b0010111

`define JAL 7'b1101111

`define BEQ 7'b1100011
`define BNE 7'b1100011
`define BLT 7'b1100011
`define BGE 7'b1100011
`define BLTU 7'b1100011
`define BGEU 7'b1100011

`define SB 7'b0100011
`define SH 7'b0100011
`define SW 7'b0100011

`define JALR 7'b1100111
`define LB 7'b0000011
`define LH 7'b0000011
`define LW 7'b0000011
`define LBU 7'b0000011
`define LHU 7'b0000011
`define ADDI 7'b0010011
`define SLTI 7'b0010011
`define SLTIU 7'b0010011
`define XORI 7'b0010011
`define ORI 7'b0010011
`define ANDI 7'b0010011

module imm_gen #(
    parameter WORD_SIZE = 32,
    parameter PC_SIZE = 64
)   (
        input [WORD_SIZE-1:0] i_inst,
        output reg [PC_SIZE-1:0] o_imm_gen
    );

    always @(*) begin
        $display("inst: %X | inst[6:0]: %X", i_inst, i_inst[6:0]);
        case (i_inst[6:0])
            `JALR, `LB, `LH, `LW, `LBU, `LHU, `ADDI, `SLTI, `SLTIU, `XORI, `ORI, `ANDI: begin   // I - type
                $display("I-Type instuction - imm: %X", i_inst[31:20] );
                // Pagina 12 RISC-V specs 2.2
                o_imm_gen = { { 21{i_inst[31]} } , i_inst[30:25], i_inst[24:21], i_inst[20]};
            end
            `SB, `SH, `SW: begin                                                                // S - type
                $display("S-Type instuction - imm: %X", {i_inst[31:25], i_inst[11:7]} );
                // Pagina 12 RISC-V specs 2.2
                o_imm_gen = { { 21{i_inst[31]} } , i_inst[30:25], i_inst[11:8], i_inst[7]};
            end
            `BEQ, `BNE, `BLT, `BGE, `BLTU, `BGEU: begin                                         // B - type
                $display("B-Type instuction - imm: %X", { i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0 } );
                // Pagina 12 RISC-V specs 2.2
                o_imm_gen = { { 20{i_inst[31]} } , i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0 };
            end
            `LUI, `AUIPC: begin                                                                 // U - type
                $display("U-Type instuction - imm: %X", i_inst[31:12] );
                // Pagina 12 RISC-V specs 2.2
                o_imm_gen = { i_inst[31], i_inst[30:20], i_inst[19:12], { 12{1'b0} } };
            end
            `JAL: begin                                                                         // J - type
                $display("J-Type instuction - imm: %X", {i_inst[31], i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0} );
                // Pagina 12 RISC-V specs 2.2
                o_imm_gen = { { 12{i_inst[31]} }, i_inst[19:12], i_inst[20], i_inst[30:25], i_inst[24:21], 1'b0 };
            end
            default: begin
                o_imm_gen = 0;
            end 
        endcase
    end
        
endmodule
