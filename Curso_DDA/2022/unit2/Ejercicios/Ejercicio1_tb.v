`timescale 1ns/1ps
`include "Ejercicio1.v"
`define BITS 13
`define SESGO 7
`define SIGNO 1
`define EXPONENTE 4
`define MANTISA 8

module sugerido1_tb;

    // Entradas
    reg [`BITS-1:0]data_x;
    reg [`BITS-1:0]data_y;
    reg clk;

    // Salidas
    wire [`BITS-1:0]data_z;

    // UUT
    sugerido1 #(
        .bits(`BITS),
        .exponente(),
        .mantisa()
        ) uut (
        .i_data_x(data_x),
        .i_data_y(data_y),
        .o_data_z(data_z)
    );

    
    initial begin
        // Se configuran los archivos en donde se imprimen las senales
        $display("signo: %d | sesgo: %d", uut.signo, uut.sesgo);
        $display("bits-signo: %d | sesgo: %d", (uut.bits-uut.signo), uut.sesgo);
        $dumpfile("Ejercicio1_tb.vcd");
        $dumpvars(2, sugerido1_tb);

        data_x = 0;
        data_y = 0;
        clk = 0;
    end

    always #1 clk = !clk;

    always @(posedge clk) begin
        data_x = $random%255;
        data_y = $random%255;

        $display("[%g] X: %d | Y: %d | Z: %d", $time, data_x, data_y, data_z);
        if ($time > 100) $finish;
    end

endmodule