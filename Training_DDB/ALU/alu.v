// RV32I Base Instruction Set
// Contiene 47 instrucciones < 6 bits de opcode+func3+func7 (2^6 = 64)

// Integer Register-Immediate Instructions //////////////////////////////////////////////
//imm[11:0] rs1 000 rd 0010011 ADDI
`define ALU_ADDI    0
//imm[11:0] rs1 010 rd 0010011 SLTI - Set Less Than Immediate
`define ALU_SLTI  1
//imm[11:0] rs1 011 rd 0010011 SLTIU - Set Less Than Immediate Unsigned
`define ALU_SLTIU  2
//imm[11:0] rs1 111 rd 0010011 ANDI
`define ALU_ANDI     3
//imm[11:0] rs1 110 rd 0010011 ORI
`define ALU_ORI      4
//imm[11:0] rs1 100 rd 0010011 XORI
`define ALU_XORI     5
//0000000 shamt rs1 001 rd 0010011 SLLI - Shift Left Logical Immediate
`define ALU_SLLI     6
//0000000 shamt rs1 101 rd 0010011 SRLI - Shift Right Logical Immediate
`define ALU_SRLI     7
//0100000 shamt rs1 101 rd 0010011 SRAI - Shift Right Arithmetical Immediate
`define ALU_SRAI     8

//imm[31:12] rd 0110111 LUI - Load Upper Immediate
`define ALU_LUI  9// Solo debo pasar { 20 MSB, 12{1'b0} } a la salida de la ALU

//imm[31:12] rd 0010111 AUIPC - Add Upper Immediate to PC
`define ALU_AUIPC  10

// Integer Register-Register Operations /////////////////////////////////////////////////
//0000000 rs2 rs1 000 rd 0110011 ADD
`define ALU_ADD    11
//0000000 rs2 rs1 010 rd 0110011 SLT - Set Less Than ( A < B? 1 : 0)
`define ALU_SLT  12
//0000000 rs2 rs1 011 rd 0110011 SLTU - Set Less Than Unsigned
`define ALU_SLTU  13
//0000000 rs2 rs1 111 rd 0110011 AND
`define ALU_AND     14
//0000000 rs2 rs1 110 rd 0110011 OR
`define ALU_OR      15
//0000000 rs2 rs1 100 rd 0110011 XOR
`define ALU_XOR     16
//0000000 rs2 rs1 001 rd 0110011 SLL - Shift Left Logical
`define ALU_SLL     17
//0000000 rs2 rs1 101 rd 0110011 SRL - Shift Right Logical
`define ALU_SRL     18
//0100000 rs2 rs1 000 rd 0110011 SUB
`define ALU_SUB   19
//0100000 rs2 rs1 101 rd 0110011 SRA - Shift Right Arithmetical
`define ALU_SRA     20

// Unconditional Jumps //////////////////////////////////////////////////////////////////
//imm[20|10:1|11|19:12] rd 1101111 JAL - Jump And Link
`define ALU_JAL  21

//imm[11:0] rs1 000 rd 1100111 JALR - Jump And Link Register
`define ALU_JALR  22

// Conditional Branches /////////////////////////////////////////////////////////////////
//imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 BEQ - Branch Equal
`define ALU_BEQ  23
//imm[12|10:5] rs2 rs1 001 imm[4:1|11] 1100011 BNE - Branch Not Equal
`define ALU_BNE  24
//imm[12|10:5] rs2 rs1 100 imm[4:1|11] 1100011 BLT - Branch Less Than
`define ALU_BLT  25
//imm[12|10:5] rs2 rs1 110 imm[4:1|11] 1100011 BLTU - Branch Less Than Unsigned
`define ALU_BLTU  26
//imm[12|10:5] rs2 rs1 101 imm[4:1|11] 1100011 BGE - Branch Greater Equal
`define ALU_BGE  27
//imm[12|10:5] rs2 rs1 111 imm[4:1|11] 1100011 BGEU - Branch Greater Equal Unsigned
`define ALU_BGEU  28

// Load and Store Instructions //////////////////////////////////////////////////////////
//imm[11:0] rs1 000 rd 0000011 LB - Load Byte
`define ALU_LB  29
//imm[11:0] rs1 001 rd 0000011 LH - Load Half-word
`define ALU_LH  30
//imm[11:0] rs1 010 rd 0000011 LW - Load Word
`define ALU_LW  31
//imm[11:0] rs1 100 rd 0000011 LBU - Load Byte Unsigned
`define ALU_LBU  32
//imm[11:0] rs1 101 rd 0000011 LHU - Load Half-word Unsigned
`define ALU_LHU  33

//imm[11:5] rs2 rs1 000 imm[4:0] 0100011 SB - Store Byte
`define ALU_SB  34
//imm[11:5] rs2 rs1 001 imm[4:0] 0100011 SH - Store Half-word
`define ALU_SH  35
//imm[11:5] rs2 rs1 010 imm[4:0] 0100011 SW - Store Word
`define ALU_SW  36
/////////////////////////////////////////////////////////////////////////////////////////
// Se descartaron algunas funciones por el momento, pero agregarlas en un futuro no deberia implicar mucho dificultad

module alu_nbit #(
    parameter BITS = 32
) (
    input [BITS-1:0] A,         // Puede ser PC o rd1
    input [BITS-1:0] B,         // Puede ser rd2 o Imm
    input [5:0] opcode,         // Senal que indica que operacion se debe ejecutar, esto viene del modulo de control
    output reg [BITS-1:0] R,    //
    output reg branch_flag,     // Bit que se pone en uno cuando se debe ejecutar un branch
    output reg zero_flag        // Bit que se pone en zero cuando el resultado de la operacion es zero
);
    always @(*) begin
        case (opcode)
            `ALU_ADDI: begin //imm[11:0] rs1 000 rd 0010011 ADDI
                R = A + B;
                branch_flag = 0;
            end
            `ALU_SLTI: begin //imm[11:0] rs1 010 rd 0010011 SLTI - Set Less Than Immediate
                R = (A < B)? 1 : 0;
                branch_flag = 0;
            end
            `ALU_SLTIU: begin //imm[11:0] rs1 011 rd 0010011 SLTIU - Set Less Than Immediate Unsigned
                R = ($unsigned(A) < $unsigned(B))? 1 : 0;
                branch_flag = 0;
            end
            `ALU_ANDI: begin //imm[11:0] rs1 111 rd 0010011 ANDI
                R = A & B;
                branch_flag = 0;
            end
            `ALU_ORI: begin //imm[11:0] rs1 110 rd 0010011 ORI
                R = A | B;
                branch_flag = 0;
            end
            `ALU_XORI: begin //imm[11:0] rs1 100 rd 0010011 XORI
                R = A ^ B;
                branch_flag = 0;
            end
            `ALU_SLLI: begin //0000000 shamt rs1 001 rd 0010011 SLLI - Shift Left Logical Immediate
                R = A << B[4:0];
                branch_flag = 0;
            end
            `ALU_SRLI: begin //0000000 shamt rs1 101 rd 0010011 SRLI - Shift Right Logical Immediate
                R = A >> B[4:0];
                branch_flag = 0;
            end
            `ALU_SRAI: begin //0100000 shamt rs1 101 rd 0010011 SRAI - Shift Right Arithmetical Immediate
                R = A >> B[4:0];
                branch_flag = 0;
            end
            `ALU_LUI: begin //imm[31:12] rd 0110111 LUI - Load Upper Immediate
                R = { B[31:12] , {12{1'b0}} };
                branch_flag = 0;
            end
            `ALU_AUIPC: begin //imm[31:12] rd 0010111 AUIPC - Add Upper Immediate to PC
                R = { B[31:12] , {12{1'b0}} } + A;
                branch_flag = 0;
            end
            `ALU_ADD: begin //0000000 rs2 rs1 000 rd 0110011 ADD
                R = A + B;
                branch_flag = 0;
            end
            `ALU_SLT: begin //0000000 rs2 rs1 010 rd 0110011 SLT - Set Less Than ( A < B? 1 : 0)
                R = (A < B)? 1 : 0;
                branch_flag = 0;
            end
            `ALU_SLTU: begin //0000000 rs2 rs1 011 rd 0110011 SLTU - Set Less Than Unsigned
                R = ($unsigned(A) < $unsigned(B))? 1 : 0;
                branch_flag = 0;
            end
            `ALU_AND: begin //0000000 rs2 rs1 111 rd 0110011 AND
                R = A & B;
                branch_flag = 0;
            end
            `ALU_OR: begin //0000000 rs2 rs1 110 rd 0110011 OR
                R = A | B;
                branch_flag = 0;
            end
            `ALU_XOR: begin //0000000 rs2 rs1 100 rd 0110011 XOR
                R = A ^ B;
                branch_flag = 0;
            end
            `ALU_SLL: begin //0000000 rs2 rs1 001 rd 0110011 SLL - Shift Left Logical
                R = A << B[4:0];
                branch_flag = 0;
            end
            `ALU_SRL: begin //0000000 rs2 rs1 101 rd 0110011 SRL - Shift Right Logical
                R = A >> B[4:0];
                branch_flag = 0;
            end
            `ALU_SUB: begin //0100000 rs2 rs1 000 rd 0110011 SUB
                R = A - B;
                branch_flag = 0;
            end
            `ALU_SRA: begin //0100000 rs2 rs1 101 rd 0110011 SRA - Shift Right Arithmetical
                R = A >> B[4:0];
                branch_flag = 0;
            end
            `ALU_JAL: begin //imm[20|10:1|11|19:12] rd 1101111 JAL - Jump And Link
                // A: PC
                R = A + 4;
                branch_flag = 0;
            end
            `ALU_JALR: begin //imm[11:0] rs1 000 rd 1100111 JALR - Jump And Link Register
                // A: Rd1 | B:Imm
                R = A + B;
                branch_flag = 0;
            end
            `ALU_BEQ: begin //imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 BEQ - Branch Equal
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = (A == B)? 1 : 0;
            end
            `ALU_BNE: begin //imm[12|10:5] rs2 rs1 001 imm[4:1|11] 1100011 BNE - Branch Not Equal
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = (A != B)? 1 : 0;
            end
            `ALU_BLT: begin //imm[12|10:5] rs2 rs1 100 imm[4:1|11] 1100011 BLT - Branch Less Than
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = (A < B)? 1 : 0;
            end
            `ALU_BLTU: begin //imm[12|10:5] rs2 rs1 110 imm[4:1|11] 1100011 BLTU - Branch Less Than Unsigned
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = ($unsigned(A) < $unsigned(B))? 1 : 0;
            end
            `ALU_BGE: begin //imm[12|10:5] rs2 rs1 101 imm[4:1|11] 1100011 BGE - Branch Greater Equal
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = (A >= B)? 1 : 0;
            end
            `ALU_BGEU: begin //imm[12|10:5] rs2 rs1 111 imm[4:1|11] 1100011 BGEU - Branch Greater Equal Unsigned
                // Levantar flag de branch dependiendo comparasion
                // Comparo flag con senal de control en el pipe
                branch_flag = ($unsigned(A) >= $unsigned(B))? 1 : 0;
            end
            `ALU_LB: begin //imm[11:0] rs1 000 rd 0000011 LB - Load Byte
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_LH: begin //imm[11:0] rs1 001 rd 0000011 LH - Load Half-word
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_LW: begin //imm[11:0] rs1 010 rd 0000011 LW - Load Word
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_LBU: begin //imm[11:0] rs1 100 rd 0000011 LBU - Load Byte Unsigned
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_LHU: begin //imm[11:0] rs1 101 rd 0000011 LHU - Load Half-word Unsigned
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_SB: begin //imm[11:5] rs2 rs1 000 imm[4:0] 0100011 SB - Store Byte
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_SH: begin //imm[11:5] rs2 rs1 001 imm[4:0] 0100011 SH - Store Half-word
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
            `ALU_SW: begin //imm[11:5] rs2 rs1 010 imm[4:0] 0100011 SW - Store Word
                //The effective byte address is obtained by adding register rs1 to the sign-extended 12-bit offset
            end
        endcase
        // Seteo (o no) el flag de resultado 0 si es necesario.
        zero_flag = (R == 0)? 1 : 0;
    end
endmodule
