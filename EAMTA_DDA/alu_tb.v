`timescale 100ns/10ns
`include "alu.v"

`define WIDTH 8


module alu_tb;

    // Entradas
    reg signed [`WIDTH-1:0]       in1_tb;
    reg signed [`WIDTH-1:0]       in2_tb;
    reg [3:0]             op_tb;
    reg [0:0]             invalid_data_tb;
    
    // Salidas
    wire signed [2*`WIDTH-1:0]    out_tb;
    wire [0:0]            zero_tb;
    wire [0:0]            error_tb;

    // Variable interna
    reg clk_tb;

    // UUT
    ALU #(.WIDTH(`WIDTH)) alu_uut (
    .in1(in1_tb),
    .in2(in2_tb),
    .op(op_tb),
    .invalid_data(invalid_data_tb),
    .out(out_tb),
    .zero(zero_tb),
    .error(error_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("alu_tb.vcd");
        $dumpvars(2, alu_tb);
        // $monitor("op: %d | in1: %X | in2: %X | out: %X | zero: %d | err: %d", op_tb, in1_tb, in2_tb, out_tb, zero_tb, error_tb);
        $monitor("op: %d | in1: %d | in2: %d | out: %d | zero: %d | err: %d", op_tb, in1_tb, in2_tb, out_tb, zero_tb, error_tb);

        // Inicializo entradas
        in1_tb = 0;
        in2_tb = 0;
        op_tb = 0;
        invalid_data_tb = 0;

        #1  // Suma
        in1_tb = $random;
        in2_tb = $random;
        op_tb = 0;
        invalid_data_tb = 0;

        #1  // Resta
        in1_tb = $random;
        in2_tb = $random;
        op_tb = 1;
        invalid_data_tb = 0;

        #1  // Multiplicacion
        in1_tb = $random;
        in2_tb = $random;
        op_tb = 2;
        invalid_data_tb = 0;

        #1  // Division: correcta
        in1_tb = $random;
        in2_tb = $random;
        op_tb = 3;
        invalid_data_tb = 0;

        #1  // Division: dividido 0
        in1_tb = $random;
        in2_tb = 0;
        op_tb = 3;
        invalid_data_tb = 0;

        #1  // Division: datos invalidos
        in1_tb = $random;
        in2_tb = $random;
        op_tb = 3;
        invalid_data_tb = 1;

        // #10
        // $finish;

    end

    always #1 clk_tb = !clk_tb;

    always @(posedge clk_tb) begin
        if ($time > 50) begin
            $finish;
        end
        else begin
            in1_tb = $random;
            in2_tb = $random;
            op_tb = $random;
        end
    end

endmodule