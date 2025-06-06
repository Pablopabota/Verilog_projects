// Aca voy a crear un modulo a partir de los otros dos (adder y display_7)
`include "adder.v"
`include "display_7.v"

module adder_display (
    x, y, a, b, c, d, e, f, g
);
    input x, y;                 //  Entradas del sumador
    output a, b, c, d, e, f, g; // Salidas del 7 segmentos
    wire w1, w0;                // valores intermedios (resultado de la suma, entrada del display)

    adder U1(x, y, w1, w0);
    display U2(w1, w0, a, b, c, d, e, f, g);

endmodule