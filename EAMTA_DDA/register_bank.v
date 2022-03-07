module register_bank #(
    parameter WIDTH = 8
    )(
    input [0:0]     clk,
    input [0:0]     rst,
    input [0:0]     wr_en,
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] mem;

    always @(posedge clk) begin
        if (rst) begin
            mem <= 0;
        end
        else if (wr_en == 1) begin
            mem <= in;
        end
        out <= mem;
    end

endmodule
