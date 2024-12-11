`timescale 100ns/10ns
`include "data_delay.v"

`define BITS 8
`define DELAY 4

module data_delay_tb;
    // Entradas
    reg [`BITS-1:0]   Din_tb;
    reg               clk_tb;
    reg               rst_tb;
    // Salidas
    wire [(`DELAY*`BITS)-1 : 0]   Dout_tb;

    // Internas

    // Instancia del UUT
    data_delay #(
        .BITS(`BITS),
        .DELAY(`DELAY)
    ) data_delay_uut (
        .i_Din(Din_tb),
        .i_clk(clk_tb),
        .i_rst(rst_tb),
        .o_Dout(Dout_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("data_delay_tb.vcd");
        $dumpvars(2, data_delay_tb);

        clk_tb = 0;
        rst_tb = 0;    // Llevo el sistema a un estado conocido
        Din_tb = 0;
    end

    always #1 clk_tb = !clk_tb;

    always @(posedge clk_tb) begin
        if ($time > 1) begin
            rst_tb = 1;
        end
        if ($time > 30) begin
            rst_tb = 0;
        end
        if ($time > 40) begin
            rst_tb = 1;
        end
        if ($time > 100) begin
            $finish;
        end
        Din_tb = $random;
    end
endmodule