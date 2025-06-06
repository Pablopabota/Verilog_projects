// Testbench for fifos multiplexer
`timescale 1ns/100ps
`default_nettype none
`define BITS    3
`include "fifo_mem.v"

module fulladder_tb;

    reg [2:0] IN;
    reg [1:0] OUT;

    fulladd uut(.a(IN[0]), .b(IN[1]), .cin(IN[2]), .s(OUT[0]), .cout(OUT[1]));

initial begin

    $dumpfile("fulladder_tb.vcd");
    $dumpvars(2,uut);
    $monitor("(time: %1d) IN=%d a=%d, b=%d, cin=%d, s=%d, cout=%d, OUT=%d", $time, IN, IN[0], IN[1], IN[2], OUT[0], OUT[1], OUT);
    IN = 3'b000;

end

always #10 IN = IN + 3'b001;
always #80 $finish;             // Aca ya da para una vuelta de todas las combinaciones posibles

endmodule

module addern_tb;

    reg cin;
    reg [`BITS-1:0] A_number;
    reg [`BITS-1:0] B_number;
    wire [`BITS-1:0] Sum;
    wire cout;

    addern #(.bits(`BITS)) uut
    (
        .carryin(cin),    // Carry-in (1-bit)
        .A(A_number),          // Vector/Numero a sumar
        .B(B_number),          // Vector/Numero a sumar
        .Sum(Sum),        // Suma de los vectores/numeros
        .carryout(cout)    // Carry-out (1-bit)
    );

    initial begin

        $dumpfile("addern_tb.vcd");
        $dumpvars(2,uut);
        $monitor("(time: %1d) A=%d B=%d, Cin=%d, Sum=%d, Cout=%d", $time, A_number, B_number, cin, Sum, cout);
        // Inicializo las variables/Entradas
        A_number = {`BITS{1'b0}};
        B_number = {`BITS{1'b0}};
        cin = 1'b0;

    end

    always #1 A_number = A_number + { {`BITS-1{1'b0}} , 1'b1}; // Una forma un poco engorrosa pero parametrizable de sumar 1 de forma precisa
    always #9 B_number = B_number + { {`BITS-1{1'b0}} , 1'b1};
    always #81 $finish;

endmodule