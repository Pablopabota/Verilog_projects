`timescale 100ns/10ns
`include "../MEM/flip-flops.v"
`define WORD_SIZE 8

module pc_reg_tb;

    reg [`WORD_SIZE-1:0] data_in_tb;
    reg rst_tb;
    reg cs_tb;
    reg we_tb;
    reg oe_tb;
    reg clk_tb;
    
    // Salidas
    wire [`WORD_SIZE-1:0] data_out_tb;

    pc_reg #(
        .WORD_SIZE(`WORD_SIZE)
    ) uut (
        .i_rst(rst_tb),
        .i_data_in(data_in_tb),
        .i_cs(cs_tb),
        .i_we(we_tb),
        .i_oe(oe_tb),
        .i_clk(clk_tb),
        .o_data_out(data_out_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("pc_reg_tb.vcd");
        $dumpvars(2, pc_reg_tb);

        // Inicializo el sistema
        clk_tb = 0;
        rst_tb = 1'b0;
        
        // Inicializo entradas
        data_in_tb = 0;
        cs_tb = 1;
        we_tb = 1;
        oe_tb = 1;

    end

    always #1 clk_tb = !clk_tb;
    always #3 data_in_tb = $random%( 2**`WORD_SIZE );
//    always #3 data_in_tb = data_in_tb + 4;
    always #10 rst_tb = !rst_tb;
    always #13 oe_tb = !oe_tb;

    always @(*) begin
        if ($time > 100) begin
            $finish;
        end        
    end

endmodule