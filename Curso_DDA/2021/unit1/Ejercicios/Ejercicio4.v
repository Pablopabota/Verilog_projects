`include "data_delay.v"
`include "pow_2_divider.v"

`define BITS 8
`define INPUT_DELAY 4
`define OUTPUT_DELAY 3

module ejercicio4 
#(
    parameter bits = `BITS
)
(
    input       [bits-1:0]  i_raw_data,
    input                   i_clk,
    input                   i_rst,
    output reg  [bits-1:0]  o_filtered_data
);    
    // Internas
    wire [(`INPUT_DELAY*bits)-1:0] delayed_input_data;
    wire [(`OUTPUT_DELAY*bits)-1:0] delayed_output_data;
    
    wire [bits-1:0] delayed_filtered_data_1;
    wire [bits-1:0] delayed_filtered_data_2;

    // Instancias de modulos utilizados
    data_delay #(
        .BITS(bits),
        .DELAY(`INPUT_DELAY)
    ) input_data_delay (
        .i_Din(i_raw_data),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_Dout(delayed_input_data)
    );

    data_delay #(
        .BITS(bits),
        .DELAY(`OUTPUT_DELAY)
    ) output_data_delay (
        .i_Din(o_filtered_data),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_Dout(delayed_output_data)
    );

    pow_2_divider #(
        .BITS(bits),
        .DIVIDE(2)
    ) divide_2 (
        .i_Din( delayed_output_data[(2*bits)-1:(1*bits)] ),
        .i_clk(i_clk),
        .o_Dout(delayed_filtered_data_1)
    );

    pow_2_divider #(
        .BITS(bits),
        .DIVIDE(4)
    ) divide_4 (
        .i_Din( delayed_output_data[(3*bits)-1:(2*bits)] ),
        .i_clk(i_clk),
        .o_Dout(delayed_filtered_data_2)
    );

    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_filtered_data <= 0;
        end
        else begin
            o_filtered_data = delayed_input_data[(1*bits)-1:(0*bits)] - delayed_input_data[(2*bits)-1:(1*bits)] + delayed_input_data[(3*bits)-1:(2*bits)] + delayed_input_data[(4*bits)-1:(3*bits)] + delayed_output_data[(1*bits)-1:(0*bits)] + delayed_filtered_data_1 + delayed_filtered_data_2;
        end
    end

endmodule