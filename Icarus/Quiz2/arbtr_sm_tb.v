// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`include "quiz2_lib.v"

module arbtr_sm_tb;

    reg clk_tb, rst_tb;
    reg c_a_tb;

    wire Trn_chng_nthng_t_snd_tb;

arbtr_sm uut (
    .clk(clk_tb),
    .Trn_chng_nthng_t_snd(Trn_chng_nthng_t_snd_tb),
    .c_a(c_a_tb),
    .rst(rst_tb)
    );

initial begin
    $dumpfile("arbtr_sm_tb.vcd");
    $dumpvars(1,uut);
    $monitor("clk_tb=%d, rst=%d c_r=%d, cur_e=%d, fut_e=%d", clk_tb, rst_tb, c_a_tb, uut.cur_e, uut.fut_e);
    rst_tb = 'b1;
    clk_tb = 'b0;
    c_a_tb = 'b0;
end

always #2 clk_tb = !clk_tb;
always #6 c_a_tb = !c_a_tb;

always @(posedge clk_tb) begin

    if ($time > 60) begin
        $finish;        // Termino la simulacion  
    end
end
    
endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -g2012 -o <name>.vvp <name>.v   --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp <name>.vvp                           --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                                  --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla