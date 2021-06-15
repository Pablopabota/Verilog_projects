//  Libro: Fundamentals of Digital Logic with Verilog Design
//  Ejercicio ejemplo 2.29: Write Verilog code that represents the logic circuit in Figure 2.70. Use only continuous
//                          assignment statements to specify the required functions.
module example_2_29 (
    x, y, z, g, f
);
    input x, y, z;
    output f, g;

    wire k;

    // Utilizo asignacion continua
    assign k = y ^ z;
    assign g = k ^ x;
    // f es la salida del selector (multiplico por 1 la expresion que quiero que pase)
    assign f = (~k & z) | (k & x);

endmodule