// Se crea un selector sencillo controlado por 1 bit
// Se utliza la programacion de asignacion continua
module mux_2_to_1_a (x, a, b, y);
    // a y b son las entradas a seleccionar
    // x es el bit de control del selector
    input x, a, b;
    // y es la salida del selector
    output y;

    // Este tipo de asignacion esta constantemente ejecutando la orden
    // para disminuir la carga del compilador se utiliza el bloque always
    assign y = (~x & a) | (x & b);

endmodule
// El mismo selector pero utilizando programacion comportamental
module mux_2_to_1_b (x, a, b, y);
    input x, a, b;
    output reg y;   // Dado que solo se asigna cuando se ejecuta el bloque always
                    // debo definirlo como un registro para que "conserve" su valor

    // En la programacion comportamental, se ejecuta el bloque "always"
    // Cada vez que alguna de las señales de sensibilidad cambia @(señales_de_sensibilidad)
    always @(x or a or b) begin
        // Si se elige la entra 0 (x = 0) la salida es a (y = a)
        if (x == 0)
            assign  y = a;
        else // (x == 1)
            assign y = b;
    end

endmodule
