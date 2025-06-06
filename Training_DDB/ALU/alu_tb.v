`timescale 100ns/1ns
`include "alu.v"
`define BITS    4

module alu_tb;

    reg     [`BITS-1:0] valor_A;
    reg     [`BITS-1:0] valor_B;
    reg     [2:0]       opcode_tb;
    wire    [`BITS-1:0] Result;

    reg                 clk;

    alu_nbit_mopcode #(
        .BITS(`BITS)
        ) alu_uut (
            .A(valor_A),
            .B(valor_B),
            .opcode(opcode_tb),
            .R(Result)
        );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("alu_tb.vcd");
        $dumpvars(4, alu_tb);
        $monitor("time: %8d | A: %d | B: %d | OP: %d | R: %d\n", $time, valor_A, valor_B, opcode_tb, Result);

        valor_A = 0;
        valor_B = 0;
        opcode_tb = 0;
        clk = 0;
    end

    always #2 clk = !clk;

    always @(posedge clk) begin
        if ($time > 100) begin
            // $display("Fin de simulacion");
            $finish;
        end

        if (opcode_tb < 7) begin
            // $display("Avanza opcode");
            opcode_tb = opcode_tb + 1;
        end
        else begin
            // $display("Reinicia opcode");
            opcode_tb = 0;
        end

        // $display("cambio Valor A y B");
        valor_A = 3;
        valor_B = 2;
    end

endmodule