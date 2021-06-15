// Modulo de sumador de 2 bits
module adder (a, b, s1, s0);

    input a, b;
    output s1, s0;

    assign s1 = a & b;
    assign s0 = a ^ b;
    
endmodule