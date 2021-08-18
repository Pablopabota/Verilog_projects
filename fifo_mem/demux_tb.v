// Testbench for fifos multiplexer
`timescale 1ns/1ns
`default_nettype none
`define BITS    8
`define DEPTH   10
`include "fifo_mem.v"

module demux_tb;

    reg [$clog2(`DEPTH)-1:0] ctrl_tb;
    reg [`BITS-1:0] in_n_tb;
    wire [`DEPTH-1:0] [`BITS-1:0] out_nm_tb ;

demuxnm #(.bits(`BITS), .depth(`DEPTH)) uut (.ctrl(ctrl_tb), .in_n(in_n_tb), .out_nm(out_nm_tb));

initial begin
    $dumpfile("demux_tb.vcd");
    $dumpvars(2,uut);
    $monitor("ctrl_tb=%d, in_n_tb=%d, out_nm_tb=%b", ctrl_tb, in_n_tb, out_nm_tb);

    for (int index = 0; index < `DEPTH; index = index + 1) begin
        ctrl_tb = index; in_n_tb = 'b0; #10;    // Coloco 0's en la salida seleccionada
    end

    $finish;
end
    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla