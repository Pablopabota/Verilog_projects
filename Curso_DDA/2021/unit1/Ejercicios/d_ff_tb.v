`timescale 100ns/10ns
`include "d_ff.v"

`define BITS 8
`define DEBUG 0

module d_ff_tb;

    reg [`BITS-1:0]  Din_tb;
    reg              clk_tb;
    reg              rst_tb;

    wire [`BITS-1:0]  Dout_tb;

    d_ff #(
        .BITS(`BITS),
        .DEBUG(`DEBUG)
    ) uut_d_ff (
        .i_Din(Din_tb),
        .i_clk(clk_tb),
        .i_rst(rst_tb),
        .o_Dout(Dout_tb)
    );
    
    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("d_ff_tb.vcd");
        $dumpvars(2, d_ff_tb);

        clk_tb = 0;
        rst_tb = 0;    // Llevo el sistema a un estado conocido
    end

    always #1 clk_tb = !clk_tb;

    always #2 Din_tb = $random%(2**`BITS);

    always @(posedge clk_tb) begin
        if ($time > 5) begin
            rst_tb = 1;
        end
        
        if ($time > 20) begin
            $finish;
        end
    end

endmodule