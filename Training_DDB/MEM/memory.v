module memory #(
    parameter ADDRESS_SIZE = 8,
    parameter BYTE_SIZE = 8,
    parameter WORD_SIZE = 32
) (
    input   [ADDRESS_SIZE-1:0]  i_address,
    input   [WORD_SIZE-1:0]     i_data_in,
    input                       i_cs,
    input                       i_we,
    input                       i_oe,
    output  [WORD_SIZE-1:0]     o_data_out
);

    // Defino el tamaño de memoria
    reg [BYTE_SIZE-1:0] mem [(2**ADDRESS_SIZE)-1:0];

    // Si esta seleccionado el chip y debo sacar el dato.. sino Z
    assign o_data_out = (i_cs && !i_we && i_oe) ? { mem [i_address+3], mem [i_address+2], mem [i_address+1], mem [i_address] } : { 32{1'bz} };

    // Siempre que cambia cs o we
    always @(*) begin
        // Si esta seleccionado y debo escribir...
        if (i_cs && i_we && !i_oe) begin
            mem[i_address+3] = i_data_in[31:24];
            mem[i_address+2] = i_data_in[23:16];
            mem[i_address+1] = i_data_in[15:8];
            mem[i_address]   = i_data_in[7:0];
        end
    end

endmodule
