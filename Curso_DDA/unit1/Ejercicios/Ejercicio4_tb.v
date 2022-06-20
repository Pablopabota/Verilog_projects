`timescale 100ns/1ns
`include "Ejercicio4.v"
`define BITS 8

module Ejercicio4_tb;
    // Entradas
    reg [`BITS-1:0]   Din_tb;
    reg               clk_tb;
    reg               rst_tb;
    // Salidas
    wire [`BITS-1 : 0]   Dout_tb;

    // Internas

    // Instancia del UUT
    ejercicio4 #(
        .BITS(`BITS)
    ) ejercicio4_uut (
        .i_raw_data(Din_tb),
        .i_clk(clk_tb),
        .i_rst(rst_tb),
        .o_filtered_data(Dout_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("Ejercicio4_tb.vcd");
        $dumpvars(2, Ejercicio4_tb);

        clk_tb = 0;
        rst_tb = 0;    // Llevo el sistema a un estado conocido
        Din_tb = 0;
    end

    always #1 clk_tb = !clk_tb;

    always @(posedge clk_tb) begin
        if ($time > 1) begin
            rst_tb = 1;
        end
        if ($time > 30) begin
            rst_tb = 0;
        end
        if ($time > 40) begin
            rst_tb = 1;
        end
        if ($time > 100000) begin
            $finish;
        end
        Din_tb = $random;
    end

endmodule