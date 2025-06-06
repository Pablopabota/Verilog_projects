// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`include "quiz2_lib.v"

module write_sm_tb;

    reg clk_tb, rst_tb;
    reg c_w_tb;

    wire rst_cntr_w_tb;
    wire rst_w_tb;
    wire bs_rqst_tb;
    wire ps_w_tb;
    wire en_w_tb;
    wire pop_tb;
    wire bs_bsy_pre_tb;

    wire [1:0] s_ds_w_tb;

write_sm uut (
    .clk(clk_tb),
    .rst_cntr_w(rst_cntr_w_tb),
    .rst_w(rst_w_tb),
    .bs_rqst(bs_rqst_tb),
    .ps_w(ps_w_tb),
    .en_w(en_w_tb),
    .pop(pop_tb),
    .c_w(c_w_tb),
    .s_ds_w(s_ds_w_tb),
    .bs_bsy_pre(bs_bsy_pre_tb),
    .rst(rst_tb)
    );

initial begin
    $dumpfile("write_sm_tb.vcd");
    $dumpvars(1,uut);
    $monitor("clk_tb=%d, rst=%d c_r=%d, cur_e=%d, fut_e=%d", clk_tb, rst_tb, c_w_tb, uut.cur_e, uut.fut_e);
    rst_tb = 'b1;
    clk_tb = 'b0;
    c_w_tb = 'b0;
end

always #2 clk_tb = !clk_tb;
always #6 c_w_tb = !c_w_tb;

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