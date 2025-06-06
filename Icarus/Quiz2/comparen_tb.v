// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define BITS    16
`include "quiz2_lib.v"

module comprn_tb;

    reg [`BITS-1:0] a_tb, b_tb;
    reg o_tb;

comprn #(`BITS) uut (
    .A(a_tb),
    .B(b_tb),
    .O(o_tb)
    );

initial begin
    $dumpfile("comprn_tb.vcd");
    $dumpvars(1,uut);
    $monitor("a_tb=%d, b_tb=%d o_tb=%d", a_tb, b_tb, o_tb);
    a_tb=16; b_tb=12; #10;
    a_tb=16; b_tb=16; #10;
    a_tb=16; b_tb=21; #10;
    $finish;
end

    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla