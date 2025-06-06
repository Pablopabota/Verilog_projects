`timescale 1ns/1ps
`include "Ejercicio2.v"

`define BITS 4

module Ejercicio2_tb;

    reg [`BITS-1:0] data1;
    reg [`BITS-1:0] data2;
    reg [1:0] sel;

    wire [`BITS-1:0] data_out;

    ejercicio2 #(
        .bits(`BITS)
    ) uut (
        .i_dataA(data1),
        .i_dataB(data2),
        .i_sel(sel),
        .o_dataC(data_out)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("Ejercicio2_tb.vcd");
        $dumpvars(0, Ejercicio2_tb);

        $monitor("[%g] dataA: %d | dataB: %d | sel: %d | out: %d", $time, data1, data2, sel, data_out);
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 0;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 0;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 1;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 1;
        #1;

        $monitor("[%g] dataA: 0x%b | dataB: 0x%b | sel: %d | out: 0x%b", $time, data1, data2, sel, data_out);
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 2;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 2;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 3;
        #1;
        data1 = $random%( 2**`BITS ); data2 = $random%( 2**`BITS ); sel = 3;
        #1;

        $finish;
    end

endmodule