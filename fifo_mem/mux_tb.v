// Testbench for fifos multiplexer
`timescale 1ns/1ns
`default_nettype none
`define BITS    8
`define DEPTH   3
`include "fifo_mem.v"

module mux_tb;

    reg [$clog2(`DEPTH)-1:0] ctrl_tb;
    reg [`DEPTH-1:0] [`BITS-1:0] in_nm_tb;
    wire [`BITS-1:0] out_n_tb ;

muxnm #(.bits(`BITS), .depth(`DEPTH)) uut (.ctrl(ctrl_tb), .in_nm(in_nm_tb), .out_n(out_n_tb));

initial begin
    $dumpfile("demux_tb.vcd");
    $dumpvars(2,uut);
    $monitor("ctrl_tb=%d, in_nm_tb=%b, out_n_tb=%d", ctrl_tb, in_nm_tb, out_n_tb);

    // Lleno las entradas con valores aleatorios
    for (int index = 0; index < `DEPTH; index = index + 1) begin
        in_nm_tb[index] = $random%( 2**`BITS );
    end

    // Cambio la señal de control y reviso la salida
    for (int index = 0; index < `DEPTH; index = index + 1) begin
        ctrl_tb = index; #10;
    end

    $finish;
end
    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla