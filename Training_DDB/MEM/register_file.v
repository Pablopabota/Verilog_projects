module reg_file_wclk #(
    parameter WORD_SIZE = 32,
    parameter READ_REG_SIZE = 5,
    parameter WRITE_REG_SIZE = 5
) (
    input   [READ_REG_SIZE-1:0]  i_rd_reg_1,
    input   [READ_REG_SIZE-1:0]  i_rd_reg_2,
    input   [WRITE_REG_SIZE-1:0] i_wr_reg,
    input   [WORD_SIZE-1:0]      i_wr_data,
    input                        i_reg_wr,
    input                        i_clk,
    input                        i_rst,
    output reg [WORD_SIZE-1:0]   o_rd_data_1,
    output reg [WORD_SIZE-1:0]   o_rd_data_2
);

    reg [WORD_SIZE-1:0] mem [(2**READ_REG_SIZE)-1:0];
    
    integer index;
    
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            for (index = 0; index < (2**READ_REG_SIZE); index = index +1) begin
                mem [index] = { WORD_SIZE{1'b0} };
            end
        end
        else begin
            if (i_rd_reg_1 != 0) begin
                o_rd_data_1 = mem [i_rd_reg_1];
            end
            if (i_rd_reg_2 != 0) begin
                o_rd_data_2 = mem [i_rd_reg_2];
            end
            if (i_reg_wr == 1'b1 && i_wr_reg != 0) begin
                mem [i_wr_reg] = i_wr_data;
            end
        end
    end

endmodule

module reg_file #(
    parameter WORD_SIZE = 32,
    parameter READ_REG_SIZE = 5,
    parameter WRITE_REG_SIZE = 5
) (
    input   [READ_REG_SIZE-1:0]  i_rd_reg_1,
    input   [READ_REG_SIZE-1:0]  i_rd_reg_2,
    input   [WRITE_REG_SIZE-1:0] i_wr_reg,
    input   [WORD_SIZE-1:0]      i_wr_data,
    input                        i_reg_wr,
    input                        i_rst,
    output reg [WORD_SIZE-1:0]   o_rd_data_1,
    output reg [WORD_SIZE-1:0]   o_rd_data_2
);

    reg [WORD_SIZE-1:0] mem [(2**READ_REG_SIZE)-1:0];
    
    integer index;
    
    always @(*) begin
        if (!i_rst) begin
            for (index = 0; index < (2**READ_REG_SIZE); index = index +1) begin
                mem [index] = { WORD_SIZE{1'b0} };
            end
        end
        else begin
            if (i_rd_reg_1 != 0) begin
                o_rd_data_1 = mem [i_rd_reg_1];
            end
            if (i_rd_reg_2 != 0) begin
                o_rd_data_2 = mem [i_rd_reg_2];
            end
            if (i_reg_wr == 1'b1 && i_wr_reg != 0) begin
                mem [i_wr_reg] = i_wr_data;
            end
        end
    end

endmodule
