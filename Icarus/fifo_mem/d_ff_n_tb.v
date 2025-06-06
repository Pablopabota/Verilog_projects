// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define BITS    8
`define DEPTH   4
`include "fifo_mem.v"

module d_ff_n_tb;

    reg clk_tb, clr_tb;
    reg [`BITS-1:0] Din_n_tb;
    wire [`BITS-1:0] Dout_n_tb ;

d_ff_n #(.bits(`BITS)) uut (.clk(clk_tb), .Din_n(Din_n_tb), .Dout_n(Dout_n_tb), .clr(clr_tb));

initial begin
    $dumpfile("d_ff_n_tb.vcd");
    $dumpvars(2,uut);
    $monitor("clk_tb=%d, clr=%d, Din_n_tb=%d, Dout_n_tb=%d", clk_tb, clr_tb, Din_n_tb, Dout_n_tb);
    clr_tb = 'b1;
    clk_tb = 'b0;
    Din_n_tb = 'b0;
end

always #2 clk_tb = !clk_tb;

always @(posedge clk_tb) begin

    Din_n_tb = $random%( 2**`BITS );

    if ($time > 10 && $time <= 20) begin
        clr_tb = 'b0;   // Enciendo el reset
    end
    
    if ($time > 20 && $time <= 100) begin
        clr_tb = 'b1;   // Apago el reset
    end

    if ($time > 100) begin
        $finish;        // Termino la simulacion  
    end
end
    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla