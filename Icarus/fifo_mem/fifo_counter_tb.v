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
    reg rst_tb;

    wire full_tb;           //  Indica que la memoria esta llena
    wire pndng_tb;          //  Indica que hay datos sin leer

    wire [$clog2(`DEPTH)-1:0] pointer_in_tb;     //  Puntero a donde guardar
    wire [$clog2(`DEPTH)-1:0] pointer_out_tb;    //  Puntero a donde leer

    fifo_counter #(.depth(`DEPTH)) uut
    (
        .clk(clk_tb),                   //  Senal de reloj
        .push(push_tb),                 //  Indica que entra un registro
        .pop(pop_tb),                   //  Indica que sale un registro
        .full(full_tb),                 //  Indica que la memoria esta llena
        .pndng(pndng_tb),               //  Indica que hay datos sin leer
        .pointer_in(pointer_in_tb),     //  Puntero a donde guardar
        .pointer_out(pointer_out_tb),   //  Puntero a donde leer
        .rst(rst_tb)
    );

    initial begin
        // Monitoreo de variables
        $dumpfile("fifo_counter_tb.vcd");
        $dumpvars(2,uut);
        $monitor("(time: %1d) clk=%d rst=%d push=%d, pop=%d, pointer in=%d, pointer out=%d, full=%d, pndng=%d, count=%d", $time, clk_tb, rst_tb, push_tb, pop_tb, pointer_in_tb, pointer_out_tb, full_tb, pndng_tb, uut.count);

        // Condicion inicial
        clk_tb = 1'b0;
        push_tb = 1'b0;
        pop_tb = 1'b0;
        rst_tb = 1'b0;
        #5;
        rst_tb = 1'b1;

    end

    always #1 clk_tb = !clk_tb;   // Arranco el clock

always @(posedge clk_tb) begin
    if ($time%3 == 0) begin
        push_tb = 1'b1; #2; push_tb = 1'b0;
    end
    else push_tb = 1'b0;

    if ($time%7 == 0) begin
        pop_tb = 1'b1; #2; pop_tb = 1'b0;
    end
    else pop_tb = 1'b0;
end

    always #50 $finish;


endmodule