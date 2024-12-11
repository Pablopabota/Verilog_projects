`include "../MEM/memory.v"
`include "../MEM/register_file.v"

`include "../COMB_BOX/imm_generator.v"

`define WORD_SIZE 32

`define REG_RD_1_INIT 15
`define REG_RD_2_INIT 20
`define REG_RD_SIZE 5

`define REG_WR_INIT 7
`define REG_WR_SIZE 5

`define RD_DATA_SIZE `WORD_SIZE
//`define PC_SIZE 2*`WORD_SIZE
`define PC_SIZE 32
`define IMM_GEN_SIZE `PC_SIZE
`define INS_MEM_SIZE `WORD_SIZE

module inst_dec (
    input       [`PC_SIZE+`WORD_SIZE-1:0]   i_if_id_reg,    // Pipeline de entrada de la entrada de decodificacion
    input       [`REG_WR_SIZE-1:0]          i_wr_reg,       // WRITE_BACK register que se quiere escribir
    input       [`WORD_SIZE-1:0]            i_wr_data,      // Datos que se quieren escribir en WRITE_BACK register
    input                                   i_reg_wr,       // Senal de control de si escribir o no el WRITE_BACK
    input                                   i_rst,
    output reg  [`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE-1:0]   o_id_ex_reg // Pipeline de salida
);

    // Cables de entrada
    wire [`REG_RD_SIZE-1:0] rd_reg_1;       // Direccion del rs1 a leer
    wire [`REG_RD_SIZE-1:0] rd_reg_2;       // Direccion del rs2 a leer
    wire [`REG_RD_SIZE-1:0] inst;           // Instruccion a ejecutar
    
    // Cables de salida                     //  PC 64 bits  | PC 32 bits
    wire [`PC_SIZE-1:0] pc_if_id;           //  [195:133]   | [132:101]
    wire [`RD_DATA_SIZE-1:0] rd_data_1;     //  [132:101]   | [100:69]
    wire [`RD_DATA_SIZE-1:0] rd_data_2;     //  [100:69]    | [68:37]
    wire [`PC_SIZE-1:0] imm_bus;            //  [68:5]      | [36:5]
    wire [`REG_WR_SIZE-1:0] wr_reg_if_id;   //  [4:0]       | [4:0]

    assign rd_reg_1 = i_if_id_reg[`REG_RD_1_INIT+`REG_RD_SIZE-1:`REG_RD_1_INIT];    // i_if_id_reg[19:15];
    assign rd_reg_2 = i_if_id_reg[`REG_RD_2_INIT+`REG_RD_SIZE-1:`REG_RD_2_INIT];    // i_if_id_reg[24:20];
    assign inst = i_if_id_reg[`INS_MEM_SIZE-1:0];                                   // i_if_id_reg[31:0];
    
    reg_file #(
        ) register_file (
    .i_rd_reg_1(rd_reg_1),
    .i_rd_reg_2(rd_reg_2),
    .i_wr_reg(i_wr_reg),        // Esto es realimentacion de un pipe en WRITE_BACK
    .i_wr_data(i_wr_data),      // Aca va la salida del MUX de WRITE_BACK
    .i_reg_wr(i_reg_wr),        // Esto lo maneja el block de CONTROL
    .i_rst(i_rst),
    .o_rd_data_1(rd_data_1),
    .o_rd_data_2(rd_data_2)      
    );
    
    imm_gen #(
    .WORD_SIZE(`WORD_SIZE),
    .PC_SIZE(`PC_SIZE)
        ) imm_generator (
        .i_inst(inst),
        .o_imm_gen(imm_bus)
    );
    
//    assign pc_if_id = i_if_id_reg[95:32];    // con PC = 64 bits
//    assign pc_if_id = i_if_id_reg[63:32];    // con PC = 32 bits
    assign pc_if_id = i_if_id_reg[`PC_SIZE+`WORD_SIZE-1:`WORD_SIZE];
//    assign wr_reg_if_id = i_if_id_reg[11:7];
    assign wr_reg_if_id = i_if_id_reg[`REG_WR_SIZE+`REG_WR_INIT-1:`REG_WR_INIT];
    
    always @(*) begin
        if (!i_rst) begin
            o_id_ex_reg = { (`PC_SIZE+`RD_DATA_SIZE+`RD_DATA_SIZE+`IMM_GEN_SIZE+`REG_WR_SIZE){1'b0} };
        end
        else begin
            o_id_ex_reg = {pc_if_id, rd_data_1, rd_data_2, imm_bus, wr_reg_if_id};
        end 
    end

endmodule