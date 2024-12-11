module pc_reg #(
    parameter WORD_SIZE = 32
) (
    input                       i_rst,
    input   [WORD_SIZE-1:0]     i_data_in,
    input                       i_cs,
    input                       i_we,
    input                       i_oe,
    input                       i_clk,
    output reg [WORD_SIZE-1:0]  o_data_out
);
    // Defino el tamaño de memoria
    reg [WORD_SIZE-1:0] mem;

    // Siempre que cambia cs o we
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            mem = {WORD_SIZE{1'b0}};
            $display("inst mem erase: %d", mem);
        end
        else begin
            if (i_cs && i_we) begin // Si esta seleccionado y debo escribir...
                mem = i_data_in;
                $display("inst mem update: %d", mem);
            end
        end
    end
    
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_data_out = { WORD_SIZE{1'bz} };
            $display("inst mem erase: %d", mem);
        end
        else begin    
            if (i_cs && i_oe) begin
                o_data_out = mem;
                $display("out inst mem: %d", o_data_out);
            end
            // Si esta seleccionado el chip y debo sacar el dato.. sino Z
            else if (i_cs && !i_oe) begin
                o_data_out = { WORD_SIZE{1'bz} };
                $display("inst mem off: %d", o_data_out);
            end
        end
    end

endmodule
