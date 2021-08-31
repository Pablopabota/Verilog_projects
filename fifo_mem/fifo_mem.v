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
    output reg[$clog2(depth)-1:0] pointer_out;  // Indica la posicion a leer datos

    //  Señales internas
    reg [$clog2(depth)-1:0] count;  // Indica la cantidad de registros en el FIFO

    // Defino dos maquinas de estado, una para el pointer in y otra para el pointer out
    output reg [$clog2(depth)-1:0] pointer_in;  // El estado es la posicion a guardar
    reg [$clog2(depth)-1:0] state_in;  // El estado es la posicion a guardar
    reg [$clog2(depth)-1:0] nxt_state_in;  // El estado es la posicion a guardar

    wire c;

    // Logica de siguiente estado
    //addern #(.bits(depth)) nxt_state_gen (.carryin(push), .A(state_in), .B('b0), .carryout(c), .Sum(nxt_state_in));

    // Aplico el cambio de estado
    always @(posedge clk or negedge rst) begin
        if (~rst) state_in <= 0;
        else begin
            state_in = nxt_state_in;
        end
    end

    // Logica de salida
    // Al ser una maquina de Moore, la salida depende del estado
    assign pointer_in = state_in;

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

// Full-Adder
module fulladd (
    cin,    //  Carry-in
    a,      //  Bit a sumar
    b,      //  Bit a sumar
    s,      //  Suma de los bits
    cout    //  Carry-out
);
    input a, b, cin;
    output s, cout;

    // Se pueden asignar varias 'variables' separando cada asignacion con una coma en vez de punto-y-coma
    assign s = (a ^ b) ^ cin;
    assign cout = (b & cin) | (a & b) | (a & cin);

endmodule

// En este caso se instancia n-veces un modulo por medio del bloque 'generate'
// Cada instancia del modulo 'fulladd' sera renombrado addbit[k].stage
module addern #(
    parameter bits = 8  // Parametro para largo del registro
)
(
    carryin,    // Carry-in (1-bit)
    A,          // Vector/Numero a sumar
    B,          // Vector/Numero a sumar
    Sum,        // Suma de los vectores/numeros
    carryout    // Carry-out (1-bit)
);
    input carryin;
    input [bits-1:0] A;
    input [bits-1:0] B;

    output [bits-1:0] Sum;
    output carryout;
    
    wire [bits:0] C;    // Esta instancia sirve para unir los carrys. Tiene 1 bit mas que lo demas para el carry-out

    genvar index;   // Tipo de variable similar a integer, pero unicamente positivo y utilizable solo en bloques generate
    assign C[0] = carryin;
    assign carryout = C[bits];

    generate    // Aca instancio bit-a-bit cada sumador y realizo la suma del numero
      for (index = 0; index <= bits-1; index = index+1) begin:addbit    // Aca se renombra cada instancia
            fulladd stage (C[index], A[index], B[index], Sum[index], C[index+1]);
        end
    endgenerate

endmodule