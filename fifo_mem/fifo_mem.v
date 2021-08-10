module fifo_counter (
    clk,            //  Senal de reloj
    push,           //  Indica que entra un registro
    pop,            //  Indica que sale un registro
    full,           //  Indica que la memoria esta llena
    pndng,          //  Indica que hay datos sin leer
    pointer_in,     //  Puntero a donde guardar
    pointer_out,    //  Puntero a donde leer
    rst
);
    // defino la profundidad del fifo que maneja
    parameter depth = 8;

    // Señales de entrada
    input clk, push, pop, rst;

    // Señales de salida
    output full, pndng;
    output reg[depth:0] pointer_in;
    output reg[depth:0] pointer_out;

    //  Señales internas

always @(posedge clk or rst) begin

    if(rst == 1) begin
        pointer_in <= 0;
        pointer_out <= 0;
        full <= 0;
        pndng <= 0;
    end

    if(push == 1) begin
        pointer_in =  pointer_in + 1;
    end
    else if (pop == 1) begin
        pointer_out = pointer_out + 1;
    end


end
endmodule

module muxnm (
    ctrl,  // Entradas de control
    in_n,   // Entrada de N Bits
    out_nm  // M salidas de N bits
);
    parameter bits = 8;     // Parametro para largo del registro
    parameter depth = 4;    // Parametro para cantidad de registros

    input [$clog2(depth)-1:0] ctrl; // Si debo demux DEPTH señales preciso Log_2(DEPTH) bits de control
    input [bits-1:0] out_nm [depth-1:0];
    output [bits-1:0] in_n;

    always @(*) begin
        out_nm[ctrl] = in_n;
    end

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
        out_n = in_nm[ctrl];
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

module fifo (
    clk,
    Din,
    Dout,
    push,
    pop,
    full,
    pndng,
    rst
);
    parameter bits = 8;
    parameter depth = 4;

    input clk, push, pop, rst;
    input Din;

    output full, pndng;
    output Dout;

    reg count;

    wire pointer_in, pointer_out;
    wire out_nm_mux;
    wire in_nm_demux;

    fifo_counter U1(.push(push), .pop(pop), .pointer_in(pointer_in), .pointer_out(pointer_out));
    muxnm U2(.ctrl(pointer_in), .in_n(Din), .out_nm(out_nm_mux));
    d_ff_n U3(clk, .Din(out_nm_mux), .Dout(in_nm_demux));
    demuxnm U4(.ctrl(pointer_out), .in_nm(in_nm_demux), .out_n(Dout));


endmodule