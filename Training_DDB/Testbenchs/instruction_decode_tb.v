`timescale 100ns/10ns
`include "../RISC-V/instruction_decode.v"

`define WORD_SIZE 32
`define PC_SIZE 64
`define READ_REG_SIZE 5
`define WRITE_REG_SIZE 5

module instruction_decode_tb;

    reg [`PC_SIZE+`WORD_SIZE-1:0] if_id_reg_tb; // PC + Instruccion
    reg [`WRITE_REG_SIZE-1:0] wr_reg_tb;              // Direccion del registro a escribir
    reg [`WORD_SIZE-1:0] wr_data_tb;            // Dato a escribir en el registro
    reg                  reg_wr_tb;             // Enable de escritura de dato (lo habilita el bloque de CONTROL)
    reg                  rst_tb;
    // Salidas
    wire [`PC_SIZE+2*`WORD_SIZE+`PC_SIZE+`WRITE_REG_SIZE-1:0] id_ex_reg_tb;         // PC + Read Data 1 + Read Data 2 + Imm + Write register

    inst_dec #() inst_dec_uut (
        .i_if_id_reg(if_id_reg_tb),
        .i_wr_reg(wr_reg_tb),                   // Esto es realimentacion de un pipe en WRITE_BACK
        .i_wr_data(wr_data_tb),                 // Aca va la salida del MUX de WRITE_BACK
        .i_reg_wr(reg_wr_tb),                   // Esto lo maneja el block de CONTROL
        .i_rst(rst_tb),
        .o_id_ex_reg(id_ex_reg_tb)
    );

    integer index;
    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("instruction_decode_tb.vcd");
        $dumpvars(4, instruction_decode_tb);

        // Inicializo el sistema
        if_id_reg_tb = 0;
        wr_reg_tb = 0;
        wr_data_tb = 0;
        reg_wr_tb = 1'b0;
        rst_tb = 1'b0;
        
        #5
        rst_tb = 1'b1;
        
        inst_dec_uut.register_file.mem[0] = 0;
        for (index = 1; index < (2**`READ_REG_SIZE); index = index +1) begin
            inst_dec_uut.register_file.mem[index] = index + 64;
        end

    end

//    always #1 $display("rst: %d", rst_tb);
    always #2 if_id_reg_tb = $random;

    always @(*) begin
        if ($time > 100) begin
            $finish;
        end        
    end

endmodule