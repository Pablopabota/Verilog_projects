`timescale 100ns/10ns
`include "register_bank.v"

`define WIDTH 8

module register_bank_tb;

    // Entradas
    reg [0:0]     clk_tb;
    reg [0:0]     rst_tb;
    reg [0:0]     wr_en_tb;
    reg [`WIDTH-1:0] in_tb;

    // Salidas
    wire [`WIDTH-1:0] out_tb;

    // UUT
    register_bank #(.WIDTH(`WIDTH)) register_bank_uut (
    .clk(clk_tb),
    .rst(rst_tb),
    .wr_en(wr_en_tb),
    .in(in_tb),
    .out(out_tb)
    );

    //inicializo sistema
    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("register_bank_tb.vcd");
        $dumpvars(2, register_bank_tb);
        $monitor("[%t] clk: %d | rst: %d | wr_en: %d | in: %d | out: %d", $time, clk_tb, rst_tb, wr_en_tb, in_tb, out_tb);

        clk_tb = 0;
        rst_tb = 1;
        in_tb = 0;
        wr_en_tb = 0;
    end

    always #1 clk_tb = !clk_tb;
    always #2 in_tb = $random;
    always #3 wr_en_tb = !wr_en_tb;

    always @(posedge clk_tb) begin
        if ($time > 50) begin
            $finish;
        end

        if ($time > 5) begin
            rst_tb = 0;
        end
    end


endmodule