`timescale 100ns/1ns
`include "pow_2_divider.v"
`define BITS 8
`define DIVIDE 4

module pow_2_divider_tb;
    
    reg i_clk;
    reg [`BITS-1:0] i_Din;
    // reg [`BITS-1:0] o_Dout; // Para IC
    wire [`BITS-1:0] o_Dout;  // Para FPGA

    pow_2_divider #(
        .DIVIDE(`DIVIDE),
        .BITS(`BITS)
    ) uut (
        .i_Din(i_Din),
        .i_clk(i_clk),
        .o_Dout(o_Dout)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("pow_2_divider_tb.vcd");
        $dumpvars(2, pow_2_divider_tb);
        $monitor("time: %4d | Din: %4b (%4d) | Dout: %4b (%4d) | testbench", $time, i_Din, i_Din, o_Dout, o_Dout);  // Para FPGA

        i_clk = 0;
        i_Din = 0;
    end

    always #2 i_clk = !i_clk;

    always @(posedge i_clk) begin
        if ($time > 34) begin
            $finish;
        end
        if ($time%2 == 0) begin
            i_Din <= $random%(2**`BITS);
        end
    end

endmodule