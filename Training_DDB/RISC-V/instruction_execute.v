`include "../ALU/alu.v"
`include "../MUX/mux.v"
`include "../SUM/adder.v"

`define WORD_SIZE 32

`define RD_DATA_SIZE `WORD_SIZE

`define REG_WR_INIT 7
`define REG_WR_SIZE 5

//`define PC_SIZE 2*`WORD_SIZE
`define PC_SIZE 32
`define IMM_GEN_SIZE `PC_SIZE
`define INS_MEM_SIZE `WORD_SIZE

module inst_exe (
    input [`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:0]   i_id_ex_reg,
    input [1:0] i_wb,       // Bits de control del WB (Sigue de largo)
    input [2:0] i_m,        // Bits de control de la Memoria (Sigue de largo)
    input [8:0] i_ex,       // Bit de control de la ejecucion
                            // [8] mux_adder, [7] mux_alu_a, [6] mux_alu_b, [5:0] alu_opcode
    input i_rst,
    output reg [`PC_SIZE+2+(2*`WORD_SIZE)+`REG_WR_SIZE-1:0]o_ex_mem_reg
);
    // Senales de entrada
    wire [`PC_SIZE-1:0] pc;
    wire [`RD_DATA_SIZE-1:0] rd1;
    wire [`RD_DATA_SIZE-1:0] rd2;
    wire [`IMM_GEN_SIZE-1:0] Imm;
    
    // Senales de control de entrada
    wire [5:0] alu_opcode;
    wire mux_adder_os;
    wire mux_alu_a_os;
    wire mux_alu_b_os;
    
    // Senales de salida
    wire [`PC_SIZE-1:0] adder_pc_o;
    wire zero_flag_o;
    wire branch_flag_o;
    wire [`WORD_SIZE-1:0] alu_o;
    wire [`WORD_SIZE-1:0] rd2_o;
    wire [`REG_WR_SIZE-1:0] wr_reg_id_ex;
    
    // Senales internas
    wire [`PC_SIZE-1:0] mux_adder_o;
    wire [`PC_SIZE-1:0] mux_alu_a_o;
    wire [`PC_SIZE-1:0] mux_alu_b_o;
    wire [`PC_SIZE-1:0] shifted_imm;
    
    //  PC 64 bits  | PC 32 bits    | Que es 'i_id_ex_reg'
    //  [195:133]   | [132:101]     | PC
    //  [132:101]   | [100:69]      | rd_data_1 (32 bits)
    //  [100:69]    | [68:37]       | rd_data_2 (32 bits)
    //  [68:5]      | [36:5]        | imm_bus
    //  [4:0]       | [4:0]         | wr_reg_if_id  (este sigue de largo)
    assign pc = i_id_ex_reg[`PC_SIZE+(2*`RD_DATA_SIZE)+`IMM_GEN_SIZE+`REG_WR_SIZE-1:(2*`RD_DATA_SIZE)+`IMM_GEN_SIZE+`REG_WR_SIZE];
    assign rd1 = i_id_ex_reg[(2*`RD_DATA_SIZE)+`IMM_GEN_SIZE+`REG_WR_SIZE-1:`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE];
    assign rd2 = i_id_ex_reg[`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:`IMM_GEN_SIZE+`REG_WR_SIZE];
    assign Imm = i_id_ex_reg[`IMM_GEN_SIZE+`REG_WR_SIZE-1:`REG_WR_SIZE];
    assign shifted_imm = Imm << 1;
    
    // Senales de control
    assign mux_adder_os = i_ex[8];
    assign mux_alu_a_os = i_ex[7];
    assign mux_alu_b_os = i_ex[6];
    assign alu_opcode = i_ex[5:0];
    
    // Selecciona entre PC o rd1 hacia el sumador    
    mux21_nbits #(
        .BITS(`PC_SIZE)
        ) add_mux (
            .os(mux_adder_os),
            .data_0(pc),
            .data_1(rd1),
            .data_out(mux_adder_o)
    );
    // Selecciona entre PC o rd1 hacia la ALU
    mux21_nbits #(
        .BITS(`PC_SIZE)
        ) alu_mux_a (
            .os(mux_alu_a_os),
            .data_0(pc),
            .data_1(rd1),
            .data_out(mux_alu_a_o)
    );
    // Selecciona entre rd2 o Imm
    mux21_nbits #(
        .BITS(`PC_SIZE)
        ) alu_mux_b (
            .os(mux_alu_b_os),
            .data_0(rd2),
            .data_1(Imm),
            .data_out(mux_alu_b_o)
    );
    adder_nbits #(
        .BITS(`PC_SIZE)
        ) adder_ex (
            .i_data_a(mux_adder_o), // Puede ser PC (0) o rd1 (1)
            .i_data_b(shifted_imm), //
            .o_data_out(adder_pc_o) //
    );
    alu_nbit #(
        .BITS(`WORD_SIZE)
        ) ex_alu (
            .A(mux_alu_a_o),// Puede ser PC o rd1
            .B(mux_alu_b_o),// Puede ser rd2 o Imm
            .opcode(alu_opcode),// Senal que indica que operacion se debe ejecutar, esto viene del modulo de control
            .R(alu_o),//
            .branch_flag(branch_flag_o),// Bit que se pone en uno cuando se debe ejecutar un branch
            .zero_flag(zero_flag_o)// Bit que se pone en zero cuando el resultado de la operacion es zero
    );
    
    assign rd2_o = rd2;
    assign wr_reg_id_ex = i_id_ex_reg[`REG_WR_SIZE-1:0];
    
    always @(*) begin
        if (!i_rst) begin
            o_ex_mem_reg = { (`PC_SIZE+2+(2*`WORD_SIZE)+`REG_WR_SIZE){1'b0} };
        end
        else begin
            o_ex_mem_reg = { adder_pc_o, zero_flag_o, branch_flag_o, alu_o, rd2_o, wr_reg_id_ex};
        end 
    end
    
endmodule