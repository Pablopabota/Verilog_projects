`timescale 1ns/100ps
`default_nettype none
`define BITS    16
`define DEPTH   16
`include "fifo_mem.v"

module sim_fifo:

    //Entradas
    reg clk;
    reg rst;
    reg [`BITS-1:0] Din;
    reg push;
    reg pop;

    //Salidas
    wire [`BITS-1:0] Dout;
    wire pndng;
    wire full;

    //Instancia UUT
    fifo_flops #(`DEPTH, `BITS) uut(
        .clk(clk),
        .Din(Din),
        .Dout(Dout),
        .push(push),
        .pop(pop),
        .full(full),
        .pndng(pndng),
        .rst(rst)
    );

initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(2,uut);
    clk = 0;
    rst = {1'b1};
    push = 0;
    pop = 0;
    Din = 0;
end

always #1 clk = !clk;

always @(posedge clk) begin
    if ($time > 100) begin
        rst = 0;
        prueba();
    end
end

    int ciclo = 0;
    int dato = 0;

    task prueba();

        if (full == 1) begin
            ciclo = 1;
        end 

        case(ciclo)
            0:begin
                rst = 0;
                push = ~push;
                pop = 0;
                Din = dato;
                if (push == 1) begin
                    $display("at %g pushed data: %g count: %g", $time, dato, sim_fifo.uut.count);
                end
                else begin
                    dato = dato + 1;
                end
            end
            1:begin
                rst = 0;
                push = 0;
                pop = ~pop;
                Din = dato;
                if (pop==1) begin
                    $display("at %g poped data: %g count %g", $time, Dout, sim_fifo.uut.count);
                end
                if (pndng == 0) begin
                    $finish;
                end
            end
            default:begin
                $display("at %g default state %g", $time, ciclo);
                $finish;
            end
        endcase
    endtask
endmodule
