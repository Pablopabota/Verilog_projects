`timescale 1ns/1ps
`include "Ejercicio1.v"

module sugerido1_tb;
    
    reg [2:0] data1;
    reg [2:0] data2;
    reg [1:0] sel;
    reg rst;
    reg clk;

    wire [5:0] data_out;
    wire ovrflw;

    sugerido1 uut (
        .i_data1(data1),
        .i_data2(data2),
        .i_sel(sel),
        .o_data(data_out),
        .i_rst_n(rst),
        .clk(clk),
        .o_overflow(ovrflw)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("Ejercicio1_tb.vcd");
        $dumpvars(0, sugerido1_tb);

        data1 = 0;
        data2 = 0;
        sel = 0;
        clk = 0;
        rst = 0;    // Llevo el sistema a un estado conocido
    end

    always #1 clk = !clk;

    always @(posedge clk) begin
        data1 = 1;
        data2 = 1;
        sel = 1;
        $display("[%g] o_data: %d | o_overflow: %d", $time, data_out, ovrflw);
        if ($time > 100) $finish;
        if ($time > 0) rst = 1;
    end

endmodule