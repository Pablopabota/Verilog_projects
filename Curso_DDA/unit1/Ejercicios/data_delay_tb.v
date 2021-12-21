`timescale 100ns/1ns
`include "data_delay.v"
`define BITS 8
`define DELAY 4

module data_delay_tb;
    
    reg i_clk;
    reg i_rst;
    reg [`BITS-1:0] i_Din;
    // reg [`DELAY-1:0] [`BITS-1:0] o_Dout; // Para IC
    reg [(`DELAY * `BITS)-1:0] o_Dout;  // Para FPGA

    data_delay #(
        .DELAY(`DELAY),
        .BITS(`BITS)
    ) uut (
        .i_Din(i_Din),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_Dout(o_Dout)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("data_delay_tb.vcd");
        $dumpvars(4, data_delay_tb);
        // $monitor("Din: %d | Dout0: %d| Dout1: %d| Dout2: %d| Dout3: %d", i_Din, o_Dout[0], o_Dout[1], o_Dout[2], o_Dout[3]); // Para IC
        // $monitor("Din: %d | Dout0: %d| Dout1: %d| Dout2: %d| Dout3: %d", i_Din, o_Dout[`BITS-1:0], o_Dout[2*`BITS-1:`BITS], o_Dout[3*`BITS-1:2*`BITS], o_Dout[4*`BITS-1:3*`BITS]);  // Para FPGA
        $monitor("Din: %4d | Dout: %4d | data_scale: %4d\n", i_Din, o_Dout, uut.data_scale);  // Para FPGA

        i_clk = 0;
        i_rst = 0;    // Llevo el sistema a un estado conocido
    end

    always #1 i_clk = !i_clk;

    always @(posedge i_clk) begin
        if ($time > 3) begin
            i_rst = 1;
        end
        if ($time > 13) begin
            $finish;
        end
        i_Din = $random%(2**`BITS);
    end

endmodule