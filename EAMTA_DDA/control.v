module control (
    input wire  [0:0]  clk,
    input wire  [0:0]  rst,
    input wire  [5:0]  cmd_in,
    input wire  [0:0]  p_error,
    output reg  [0:0]  aluin_reg_en,
    output reg  [0:0]  datain_reg_en,
    output reg  [0:0]  aluout_reg_en,
    output reg  [0:0]  nvalid_data,
    output wire [1:0]  in_select_a,
    output wire [1:0]  in_select_b,
    output reg  [4:0]  opcode
);

    always @(posedge clk) begin
        if (rst) begin
            //
        end
        else begin
            // Se selecciona la entrada del multiplexor a
            in_select_a = cmd_in[5:4];
            // Se selecciona la entrada del multiplexor b
            in_select_b = cmd_in[3:2];
            // Se selecciona la operacion de la ALU
            opcode = { 2'b00, cmd_in[1:0] };
        end
    end

endmodule