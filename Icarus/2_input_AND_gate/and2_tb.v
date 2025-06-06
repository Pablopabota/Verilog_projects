// Testbench for 2 input AND gate
`timescale 1ns/1ns
`include "and2.v"

module and2_tb;

    reg A;
    reg B;
    wire Y;

and2 uut(A, B, Y);

initial begin
    $dumpfile("and2_tb.vcd");
    $dumpvars(0, and2_tb);
    $monitor("A=%b, B=%b, Y=%b",A,B,Y);
    A=0; B=0; #10;
    A=0; B=1; #10;
    A=1; B=0; #10;
    A=1; B=1; #10;
    $finish;
end
    
endmodule