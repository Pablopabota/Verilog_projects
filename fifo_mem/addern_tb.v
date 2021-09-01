// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define BITS    4
`include "fifo_mem.v"

module addern_tb;

    reg cin;
    reg [`BITS-1:0] A_number;
    reg [`BITS-1:0] B_number;
    wire [`BITS-1:0] Sum;
    wire cout;

    addern #(.bits(`BITS)) uut
    (
        .carryin(cin),      // Carry-in (1-bit)
        .A(A_number),       // Vector/Numero a sumar
        .B(B_number),       // Vector/Numero a sumar
        .Sum(Sum),          // Suma de los vectores/numeros
        .carryout(cout)     // Carry-out (1-bit)
    );

    initial begin
        // Monitoreo de variables
        $dumpfile("addern_tb.vcd");
        $dumpvars(2,uut);
        $monitor("(time: %1d) A=%d B=%d, Cin=%d, Sum=%d, Cout=%d", $time, A_number, B_number, cin, Sum, cout);
        
        // Inicializo las variables/Entradas
        A_number = {`BITS{1'b0}};
        B_number = {`BITS{1'b0}};
        cin = 1'b0;

    end

    always #1 A_number = A_number + { {`BITS-1{1'b0}} , 1'b1}; // Una forma un poco engorrosa pero parametrizable de sumar 1 de forma precisa
    always #(2**`BITS) B_number = B_number + { {`BITS-1{1'b0}} , 1'b1};
    always #(2**(2*`BITS)) $finish;

endmodule