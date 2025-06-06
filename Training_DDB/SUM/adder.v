module adder_nbits #(
    parameter BITS = 4
) (
    input       [BITS-1:0]  i_data_a,     // Entrada A
    input       [BITS-1:0]  i_data_b,     // Entrada B
    output      [BITS-1:0]  o_data_out    // Resultado (1 bit mas para el carry);
);

    assign o_data_out = i_data_a + i_data_b;

endmodule