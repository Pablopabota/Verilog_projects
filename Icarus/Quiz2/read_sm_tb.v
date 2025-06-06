// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`include "quiz2_lib.v"

module read_sm_tb;

    reg clk_tb, rst_tb;
    reg c_r_tb;

    wire rdi_tb;
    wire push_tb;
    wire en_r_tb;
    wire ps_r_tb;
    wire rst_r_tb;
    wire rst_cntr_r_tb;
    wire s_cmp_tb;
    wire [1:0] s_ds_r_tb;

read_sm uut (
    .clk(clk_tb),
    .rdi(rdi_tb),
    .push(push_tb),
    .en_r(en_r_tb),
    .ps_r(ps_r_tb),
    .rst_r(rst_r_tb),
    .rst_cntr_r(rst_cntr_r_tb),
    .s_cmp(s_cmp_tb),
    .s_ds_r(s_ds_r_tb),
    .c_r(c_r_tb),
    .rst(rst_tb)
    );

initial begin
    $dumpfile("read_sm_tb.vcd");
    $dumpvars(1,uut);
    $monitor("clk_tb=%d, rst=%d c_r=%d, cur_e=%d, fut_e=%d", clk_tb, rst_tb, c_r_tb, uut.cur_e, uut.fut_e);
    rst_tb = 'b1;
    clk_tb = 'b0;
    c_r_tb = 'b0;
end

always #2 clk_tb = !clk_tb;
always #6 c_r_tb = !c_r_tb;

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