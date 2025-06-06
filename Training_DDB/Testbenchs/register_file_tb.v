`timescale 100ns/10ns
`include "../MEM/flip-flops.v"

`define ADDRESS_SIZE 32
`define WORD_SIZE 32
`define READ_REG_SIZE 5
`define WRITE_REG_SIZE 5

module register_file_tb;

    // Entradas
    reg [`READ_REG_SIZE-1:0] rd_reg_1_tb;
    reg [`READ_REG_SIZE-1:0] rd_reg_2_tb;
    reg [`WRITE_REG_SIZE-1:0] wr_reg_tb;
    reg [`WORD_SIZE-1:0] wr_data_tb;
    reg reg_wr_tb;
    reg clk_tb;
    reg rst_tb;
    
    // Salidas
    wire [`WORD_SIZE-1:0] rd_data_1_tb;
    wire [`WORD_SIZE-1:0] rd_data_2_tb;
    
    reg_file #(
        ) register_file_uut (
    .i_rd_reg_1(rd_reg_1_tb),
    .i_rd_reg_2(rd_reg_2_tb),
    .i_wr_reg( wr_reg_tb ),
    .i_wr_data(wr_data_tb),
    .i_reg_wr(reg_wr_tb),    // Esto lo controla el CONTROL
    .i_clk(clk_tb),
    .i_rst(rst_tb),
    .o_rd_data_1(rd_data_1_tb),
    .o_rd_data_2(rd_data_2_tb)      
    );
    
    integer index;
    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("register_file_tb.vcd");
        $dumpvars(2, register_file_tb);

        // Inicializo el sistema
        clk_tb = 0;
        rst_tb = 1'b1;
        
        // Inicializo entradas
        rd_reg_1_tb = 0;
        rd_reg_2_tb = 0;
        wr_data_tb = 0;
        reg_wr_tb = 1'b0;
        
        // Inicializo UUT
        register_file_uut.mem[0] = 0;
        for (index = 1; index < (2**`READ_REG_SIZE); index = index +1) begin
            register_file_uut.mem [index] = index + 64;
        end
    end
    
    always #1 clk_tb = !clk_tb;
    
    always @(posedge clk_tb) begin
        if ($time > 2) begin
            rst_tb = 1'b1;
        end
        if ($time > 85) begin
            wr_reg_tb = $random%(2**`WRITE_REG_SIZE);
            wr_data_tb = $random;
            reg_wr_tb = 1'b1;
        end
        if ($time > 100) begin
            $finish;
        end
        
        rd_reg_1_tb = $random%(2**`READ_REG_SIZE);
        rd_reg_2_tb = $random%(2**`READ_REG_SIZE);
        
        
    end
    
endmodule
