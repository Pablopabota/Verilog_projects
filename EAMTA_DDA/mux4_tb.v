`include "mux4.v"

`define WIDTH 8

module mux4_tb;

    // Entradas
    reg  [`WIDTH-1:0] din1_tb, din2_tb, din3_tb, din4_tb;
    reg  [1:0]       select_tb;
    
    // Salidas
    wire [`WIDTH-1:0] dout_tb;

    mux4 #(.WIDTH(`WIDTH)) mux4_uut (
    .din1(din1_tb), 
    .din2(din2_tb), 
    .din3(din3_tb), 
    .din4(din4_tb),
    .select(select_tb),
    .dout(dout_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("mux4_tb.vcd");
        $dumpvars(2, mux4_tb);
        $monitor("in1: %d | in2: %d | in3: %d | in4: %d | sel: %d | out: %d", din1_tb, din2_tb, din3_tb, din4_tb, select_tb, dout_tb);

        // Inicializo entradas
        din1_tb = $random;
        din2_tb = $random;
        din3_tb = $random;
        din4_tb = $random;
        select_tb = 0;
    end

    always #2 select_tb = $random;

endmodule