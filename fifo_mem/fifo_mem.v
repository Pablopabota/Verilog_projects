module fifo_counter #(
    parameter depth = 8 // defino la profundidad del fifo que maneja
)
(
    clk,            //  Senal de reloj
    push,           //  Indica que entra un registro
    pop,            //  Indica que sale un registro
    full,           //  Indica que la memoria esta llena
    pndng,          //  Indica que hay datos sin leer
    pointer_in,     //  Puntero a donde guardar
    pointer_out,    //  Puntero a donde leer
    rst
);
    // Señales de entrada
    input clk, push, pop, rst;

    // Señales de salida
    output full, pndng;
    output reg[$clog2(depth)-1:0] pointer_in;   // Indica la posicion a guardar datos
    output reg[$clog2(depth)-1:0] pointer_out;  // Indica la posicion a leer datos

    //  Señales internas
    reg [$clog2(depth)-1:0] count;  // Indica la cantidad de registros en el FIFO

    assign pndng = (count > 0) ? 1 : 0;     // Si hay algun dato en la memoria, HIGH pndng, sino LOW
    assign full = (count == depth) ? 1 : 0; // Si la cuenta alcanza la profundidad, HIGH full, sino LOW

// revisar maquina de estado
always @(posedge clk or negedge rst) begin

    if(!rst) begin
        pointer_in <= 0;
        pointer_out <= 0;
        full <= 0;
        pndng <= 0;
        count <= 0;
    end

    if(push == 1) begin
        if (pointer_in == depth) begin
            pointer_in = 0;
        end
        else begin
            pointer_in = pointer_in + 1;
        end

        count = count + 1;
    end
    else if (pop == 1) begin
        if (pointer_out == depth) begin
            pointer_out = 0;
        end
        else begin
            pointer_out = pointer_out + 1;
        end

        count = count - 1;
    end
end

endmodule

module demuxnm #(
    parameter bits = 8,     // Parametro para largo del registro
    parameter depth = 4     // Parametro para cantidad de registros
)
(
    ctrl,   // Entradas de control
    in_n,   // Entrada de N Bits
    out_nm  // M salidas de N bits
);
    input [$clog2(depth)-1:0] ctrl;         // Si tengo demux DEPTH señales preciso Log_2(DEPTH) bits de control
    input [bits-1:0] in_n;
    output [depth-1:0] [bits-1:0] out_nm ;

    // Instancio todas las salidas para mantener el control sobre estas todo el tiempo
    genvar index;
    generate
        for (index = 0; index < depth; index = index + 1) begin
            assign out_nm[index] = (ctrl == index)? in_n : 'bz;
        end
    endgenerate

endmodule

module muxnm #(
    parameter bits = 8,     // Parametro para largo del registro
    parameter depth = 4     // Parametro para cantidad de registros
)
(
    ctrl,   // Entradas de control
    in_nm,  // M entradas de N bits
    out_n   // Salida de N bits
);

    input [$clog2(depth)-1:0] ctrl; // Si debo demux DEPTH señales preciso Log_2(DEPTH) bits de control
    input [depth-1:0] [bits-1:0] in_nm ;
    output [bits-1:0] out_n;

    // A la salida tengo la entrada correspondiente al valor de ctrl
    assign out_n = in_nm[ctrl];

endmodule

// Arreglo de N Flip-Flops tipo D
module d_ff_n #(
    parameter bits = 8  // Parametro para largo del registro
)
(
    clk,      // Señal de clock
    Din_n,    // Datos de entrada de largo n
    Dout_n,   // Datos de salida de largo n
    clr
);
    input clk, clr;
    input [bits-1:0] Din_n;

    output reg [bits-1:0] Dout_n;

    always @(posedge clk or negedge clr) begin // Siempre que recibo un flanco de clk
        if (!clr) begin
            Dout_n <= 0;
        end
        else begin
            Dout_n <= Din_n;
        end
    end

endmodule

module fifo #(
    parameter bits = 8,
    parameter depth = 4
)
(
    clk,
    Din,
    Dout,
    push,
    pop,
    full,
    pndng,
    rst
);
    input clk, push, pop, rst;
    input [bits-1:0] Din;

    output full, pndng;
    output [bits-1:0] Dout;

    reg count;

    wire [$clog2(depth)-1:0] pointer_in;
    wire [$clog2(depth)-1:0] pointer_out;
    wire [bits-1:0] out_nm_mux [depth-1:0];
    wire [bits-1:0] in_nm_demux [depth-1:0];

    // fifo_counter #(depth) U1(
    //     .push(push), 
    //     .pop(pop), 
    //     .pointer_in(pointer_in), 
    //     .pointer_out(pointer_out), 
    //     .rst(rst), 
    //     .full(full), 
    //     .pndng(pndng)
    //     );
    // demuxnm #(bits, depth) U2(.ctrl(pointer_in), .in_n(Din), .out_nm(out_nm_mux));
    // d_ff_n #(bits) U3(.clk(clk), .Din_n(out_nm_mux), .Dout_n(in_nm_demux));
    // muxnm #(bits, depth) U4(.ctrl(pointer_out), .in_nm(in_nm_demux), .out_n(Dout));

endmodule