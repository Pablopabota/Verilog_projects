`include "../MEM/memory.v"
`include "../MEM/pc_register.v"

`include "../MUX/mux.v"

`include "../SUM/adder.v"

`define WORD_SIZE 32

`define PC_SIZE 2*`WORD_SIZE
`define INS_MEM_SIZE `WORD_SIZE

module inst_fetch (
    input       [`PC_SIZE-1:0]                  i_mem_pc,
    input                                       i_ctrl_mux_if,
    output reg  [`PC_SIZE+`INS_MEM_SIZE-1:0]    o_if_id_reg
);

    // INSTRUCTION FETCH SIDE
    wire [`PC_SIZE-1:0] mux_if_0;
    wire [`PC_SIZE-1:0] mux_if_out;
    wire [`PC_SIZE-1:0] pc;
    wire [`INS_MEM_SIZE-1:0] ins_bus;
    
    adder_nbits #(
        .BITS(`PC_SIZE)
        ) adder_if (
            .i_data_a(4), 
            .i_data_b(pc),
            .o_data_out(mux_if_0)
    );
    
    pc_reg #(
        .WORD_SIZE(`PC_SIZE)
        ) pc_if (
            .i_rst(i_rst),
            .i_data_in(mux_if_out),
            .i_cs(1'b1),
            .i_we(1'b1),     // Esto lo debe controlar el CONTROL
            .i_oe(1'b1),
            .i_clk(i_clk),
            .o_data_out(pc)
    );

    mux21_nbits #(
        .BITS(`PC_SIZE)
        ) mux_if (
            .os(i_ctrl_mux_if),
            .data_0(mux_if_0),
            .data_1(mem_pc),
            .data_out(mux_if_out)
    );
    
    memory #(
        .ADDRESS_SIZE(`PC_SIZE),
        .WORD_SIZE(`INS_MEM_SIZE)
        ) ins_mem (
            .i_address(pc),
            .i_data_in({32{1'bz}}),
            .i_cs(1'b1),
            .i_we(1'b0),
            .i_oe(1'b1),
            .o_data_out(ins_bus)
    );
    
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            if_id_reg = { (`PC_SIZE+`INS_MEM_SIZE){1'b0} };
        end
        else begin
            if_id_reg[(`PC_SIZE+`INS_MEM_SIZE)-1:`INS_MEM_SIZE] = pc;
            if_id_reg[`INS_MEM_SIZE-1:0] = ins_bus;
        end 
    end

endmodule