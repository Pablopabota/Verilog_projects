`include "d_ff.v"

module data_delay #(
    parameter DELAY = 4,    // Cantidad de ciclos de retardo
    parameter BITS = 8     // Tamaño de los datos a retardar
)(
    input                   i_clk,
    input                   i_rst,
    input       [BITS-1:0]  i_Din,  // Palabra a la entrada
    //output reg  [DELAY-1:0] [BITS-1:0]  o_Dout // Tengo una palabra por cada ciclo de retardo (Para IC)
    output reg  [(DELAY * BITS)-1:0]  o_Dout // Tengo una palabra por cada ciclo de retardo (Para FPGA)
);

    wire [(DELAY * BITS)-1:0] data_scale;
    
    assign data_scale = o_Dout;

    genvar index;
    generate
        for (index = 0; index <= DELAY-1; index = index + 1) begin
            if (index == 0) begin
                d_ff #(.BITS(BITS)) u_dff (
                    .i_Din(i_Din),
                    .i_clk(i_clk),
                    .i_rst(i_rst),
                    // .o_Dout(o_Dout[index])  // Para IC
                    .o_Dout(data_scale[(index+1)*BITS-1:index*BITS])  // Para FPGA
                );
            end
            else begin
                d_ff #(.BITS(BITS)) u_dff (
                    .i_Din(data_scale[index*BITS-1:(index-1)*BITS]),
                    .i_clk(i_clk),
                    .i_rst(i_rst),
                    // .o_Dout(o_Dout[index])  // Para IC
                    .o_Dout(data_scale[(index+1)*BITS-1:index*BITS])  // Para FPGA
                    );               
            end
        end
    endgenerate

endmodule