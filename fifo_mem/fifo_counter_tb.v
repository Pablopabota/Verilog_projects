// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define BITS    4
`define DEPTH   4
`include "fifo_mem.v"

module fifo_counter_tb;

    // Definicion de variables y registros
    reg clk_tb;            //  Senal de reloj
    reg push_tb;           //  Indica que entra un registro
    reg pop_tb;            //  Indica que sale un registro
    wire full_tb;           //  Indica que la memoria esta llena
    wire pndng_tb;          //  Indica que hay datos sin leer
    wire [$clog2(`DEPTH)-1:0] pointer_in_tb;     //  Puntero a donde guardar
    wire [$clog2(`DEPTH)-1:0] pointer_out_tb;    //  Puntero a donde leer
    reg rst_tb;

    fifo_counter #(.depth(`DEPTH)) uut
    (
        .clk(clk_tb),            //  Senal de reloj
        .push(push_tb),           //  Indica que entra un registro
        .pop(),            //  Indica que sale un registro
        .full(),           //  Indica que la memoria esta llena
        .pndng(),          //  Indica que hay datos sin leer
        .pointer_in(pointer_in_tb),     //  Puntero a donde guardar
        .pointer_out(),    //  Puntero a donde leer
        .rst(rst_tb)
    );

    initial begin
        // Monitoreo de variables
        $dumpfile("fifo_counter_tb.vcd");
        $dumpvars(2,uut);
        $monitor("(time: %1d) clk=%d push=%d, pointer in=%d", $time, clk_tb, push_tb, pointer_in_tb);

        // Condicion inicial
        clk_tb = 1'b0;
        push_tb = 1'b0;
        rst_tb = 1'b0;
        #1;
        rst_tb = 1'b1;

    end

    always #1 clk_tb = !clk_tb;   // Arranco el clock
    always #2 push_tb = !push_tb;
    always #50 $finish;


endmodule