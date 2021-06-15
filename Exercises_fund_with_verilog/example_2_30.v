//  Libro: Fundamentals of Digital Logic with Verilog Design
// Ejercicio ejemplo 2.30: Consider the circuit shown in Figure 2.72. It includes two copies of the 2-to-1 
//                         multiplexer Example 2.30 circuit from Figure 2.33, and the adder circuit from Figure 2.12. 
//                         If the multiplexers’ select input m = 0, then this circuit produces the sum S = a + b. 
//                         But if m = 1, then the circuit produces S = c + d. By using multiplexers, 
//                         we are able to share one adder for generating the two different sums a + b and c + d. 
//                         Sharing a subcircuit for multiple purposes is commonly-used in practice, although usually 
//                         with larger subcircuits than our one-bit adder.
//                         Write Verilog code for the circuit in Figure 2.72. Use the hierarchical style of Verilog
//                         code illustrated in Figure 2.47, including two instances of a Verilog module for the 2-to-1
//                         multiplexer subcircuit, and one instance of the adder subcircuit.

module top_level (
    m, a, b, c, d, s1, s0
);
    input m;
    input a, b, c, d;
    output s1, s0;

    wire w1, w2;    // para cada salida de los selectores

    mux_2_to_1 U1(m, a, c, w1);
    mux_2_to_1 U2(m, b, d, w2);
    adder U3(w1, w2, s1, s0);

endmodule

module mux_2_to_1 (x, a, b, y)
    input x, a, b;
    output reg y;

    always @(x or a or b) begin
        if (x = 0)
            assign y = a;
        else
            assign y = b;
    end

endmodule

module adder (a, b, s1, s0);
    input a, b;
    output s1, s0;

    assign s1 = a & b;
    assign s0 = a ^ b;
endmodule