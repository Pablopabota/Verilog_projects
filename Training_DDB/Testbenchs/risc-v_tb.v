`timescale 100ns/1ns
`include "../RISC-V/risc-v.v"

module risc_v_tb ();

    wire [31:0] pc_tb;
    reg rst_tb;
    reg clk_tb;

    risc_v uut (
        .i_rst(rst_tb),
        .i_clk(clk_tb),
        .pc(pc_tb)
    );

    initial begin
        rst_tb = 0;
        clk_tb = 0;
    end

    always #1 clk_tb = !clk_tb;
    always #5 rst_tb = !rst_tb;

    always @(*) begin
        if ($time > 5)begin
//            rst_tb = 1;
        end

        if ($time > 100)begin
            $finish;
        end
    end


endmodule