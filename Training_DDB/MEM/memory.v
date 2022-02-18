module memory #(
    parameter ADDRESS_SIZE = 8,
    parameter WORD_SIZE = 4
) (
    input   [ADDRESS_SIZE-1:0]  i_address,
    input   [WORD_SIZE-1:0]     i_data_in,
    input                       i_cs,
    input                       i_we,
    input                       i_oe,
    output  [WORD_SIZE-1:0]     o_data_out
);

    // Defino el tamaño de memoria
    reg [WORD_SIZE-1:0] mem [(2**ADDRESS_SIZE)-1:0];

    // Si esta seleccionado el chip y debo sacar el dato.. sino Z
    assign o_data_out = (i_cs && !i_we && i_oe) ? mem [i_address] : { WORD_SIZE{1'bz} };

    // Siempre que cambia cs o we
    always @(*) begin
        // Si esta seleccionado y debo escribir...
        if (i_cs && i_we && !i_oe) begin
            mem[i_address] = i_data_in;
        end
    end

endmodule
