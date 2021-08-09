module fifo_counter (
    clk,            //  Senal de reloj
    push,           //  Indica que entra un registro
    pop,            //  Indica que sale un registro
    full,           //  Indica que la memoria esta llena
    pndng,          //  Indica que hay datos sin leer
    pointer_in,     //  Puntero a donde guardar
    pointer_out,    //  Puntero a donde leer
);
    // defino la profundidad del fifo que maneja
    parameter depth = 8;

    // Señales de entrada
    input clk, push, pop;

    // Señales de salida
    output full, pndng;
    output [depth:0] pointer_in;
    output [depth:0] pointer_out;

    //  Señales internas
    

endmodule

module muxnm (
    cntrl,  // Entradas de control
    in_n,   // Entrada de N Bits
    out_nm  // M salidas de N bits
);
    parameter bits = 8;     // Parametro para largo del registro
    parameter depth = 4;    // Parametro para cantidad de registros

endmodule

module demuxnm (
    ctrl,   // Entradas de control
    in_nm,  // M entradas de N bits
    out_n   // Salida de N bits
);
    parameter bits = 8;
    parameter depth = 4;

    input [$clog2(depth)-1:0] ctrl; // Si debo demux DEPTH señales preciso Log_2(DEPTH) bits de control
    input [bits-1:0] in_nm [depth-1:0];
    output [bits-1:0] out_n;

    always @(*) begin
        
    end

endmodule

// Arreglo de N Flip-Flops tipo D
module d_ff_n (
    clk,      // Señal de clock
    Din_n,    // Datos de entrada de largo n
    Dout_n    // Datos de salida de largo n
);
    parameter bits = 8; // Parametro para largo del registro

    input clk;
    input [bits-1:0] Din_n;

    output reg [bits-1:0] Dout_n;

    always @(posedge clk) begin // Siempre que recibo un flanco de clk
        Dout_n = Din_n; // La salida pasa a ser la entrada
    end

endmodule