module sugerido1 #(
    parameter bits = 13,        // Bits totales
    parameter exponente = 4,    // Bits de exponente
    parameter mantisa = 8       // Bits de mantisa
) (
    input       [bits-1:0] i_data_x,    // Entrada X
    input       [bits-1:0] i_data_y,    // Entrada Y
    output   [bits-1:0] o_data_z     // Resultado Z
);
    // Variables internas
    wire signo_x;
    wire [exponente-1:0] exponente_x;
    wire [mantisa-1:0] mantisa_x;

    wire signo_y;
    wire [exponente-1:0] exponente_y;
    wire [mantisa-1:0] mantisa_y;

    wire signo_z;
    wire [exponente-1:0] exponente_z;
    wire [mantisa-1:0] mantisa_z;

    // Constantes
    parameter signo = 1;        // Bit de signo
    parameter sesgo = 2**(exponente-1)-1;

    assign signo_x = i_data_x[bits-signo];
    assign signo_y = i_data_y[bits-signo];

    assign exponente_x = i_data_x[bits-signo-1:bits-signo-exponente];
    assign exponente_y = i_data_y[bits-signo-1:bits-signo-exponente];
    
    assign mantisa_x = i_data_x[bits-signo-1-exponente:bits-signo-exponente-mantisa];
    assign mantisa_y = i_data_y[bits-signo-1-exponente:bits-signo-exponente-mantisa];

    // Obtengo signo del resultado
    assign signo_z = signo_x ^^ signo_y;
    
    // Obtengo mantisa del resultado
    assign exponente_z = exponente_x + exponente_y - sesgo;

    // Obtengo exponente del resultado
    assign mantisa_z = $unsigned(mantisa_x) * $unsigned(mantisa_y);

    assign o_data_z = {signo_z, exponente_z, mantisa_z};

endmodule