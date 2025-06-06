// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define MAX_VAL    16
`include "quiz2_lib.v"

module counter_to_tb;

    reg clk_tb, rst_tb;
    reg [$clog2(`MAX_VAL)-1:0] count;

counter_to #(`MAX_VAL) uut (
    .clk(clk_tb),
    .count(count),
    .rst(rst_tb)
    );

initial begin
    $dumpfile("countern.vcd");
    $dumpvars(1,uut);
    $monitor("clk_tb=%d, rst=%d count=%d", clk_tb, rst_tb, count);
    rst_tb = 'b1;
    clk_tb = 'b0;
end

always #2 clk_tb = !clk_tb;

always @(posedge clk_tb) begin

    if ($time > 70) begin
        $finish;        // Termino la simulacion  
    end
end
    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla