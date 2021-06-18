// Modulo de sumador de 2 bits
module adder (a, b, s1, s0);

    input a, b;
    output s1, s0;

    assign s1 = a & b;
    assign s0 = a ^ b;
    
endmodule

// Se propone un sumador de 1bit con Carry_out: Half Adder
module halfadd (
    s, c, x, y
);
    // Entradas: numero 'x' y numero 'y'
    input x, y;
    // Salidas suma 's' y carry_out 'c'
    output s, c;

    // 's' vale '1' solo si uno de los dos numeros vale '1'
    // sino se produce un carry_out
    assign s = x ^ y;

    // 'c' vale '1' solo cuando ambas entradas son '1'
    assign c = x & y;

endmodule

// Full-Adder
module fulladd (
    cin, x, y, s, cout
);
    input x, y, cin;
    output s, cout;

    // Se pueden asignar varias 'variables' separando cada asignacion con una coma en vez de punto-y-coma
    assign  s = x ^ y ^ cin,
            cout = (x & y) | (x & cin) | (y & cin);

endmodule

module fulladd_2 (
    cin, x_i, y_i, s_i, cout
);
    input cin, x_i, y_i;
    output s_i, cout;

    wire s_k, c_k, c_k2;  // Algunas señales intermedias necesarias

    halfadd U1(s_k, c_k, x_i, y_i);
    halfadd U2(s_i, c_k2, cin, s_k);
    or(cout, c_k, c_k2);

endmodule
// El problema con el full-adder en cascada es que cada conversion de dato intoduce un delay dT en realizar la cuenta
// por lo que una suma de n-bits tarda n*dT, siendo esto inaceptablemente lento para algunos sistema.
// Se deberan buscar otras formas de optimizar dicho tiempo.
// A este sumador se lo conoce como: "ripple-carry Adder"

// Se implementa un sumador de 4bits utilizando el fulladd previamente implementado
module adder4 (carryin, x3, x2, x1, x0, y3, y2, y1, y0, s3, s2, s1, s0, carryout);
    input carryin, x3, x2, x1, x0, y3, y2, y1, y0;
    output s3, s2, s1, s0, carryout;

    fulladd stage0 (carryin, x0, y0, s0, c1);
    fulladd stage1 (c1, x1, y1, s1, c2);
    fulladd stage2 (c2, x2, y2, s2, c3);
    fulladd stage3 (c3, x3, y3, s3, carryout);
endmodule

// Esta ultima implementacion es engorrosa ya para numeros de cuatro bits, ni hablar para otros numeros aun mayores
// Por lo que se propone utilizar señales vectoriales
module adder8 (carryin, X, Y, S, carryout);
    input carryin;
    input [7:0] X, Y;   // Defino vectores siendo X[7] el MSB y X[0] el LSB
    output [7:0] S;     // Si se define al revez, X[0] seria MSB y X[7] el LSB
    output carryout;
    wire [7:1] C;

    fulladd stage0 (carryin, X[0], Y[0], S[0], C[1]);
    fulladd stage1 (C[1], X[1], Y[1], S[1], C[2]);
    fulladd stage2 (C[2], X[2], Y[2], S[2], C[3]);
    fulladd stage3 (C[3], X[3], Y[3], S[3], C[4]);
    fulladd stage4 (C[4], X[4], Y[4], S[4], C[5]);
    fulladd stage5 (C[5], X[5], Y[2], S[5], C[6]);
    fulladd stage6 (C[6], X[6], Y[6], S[6], C[7]);
    fulladd stage7 (C[7], X[7], Y[7], S[7], carryout);
endmodule

//  Ahora lo engorroso es poner varias instancias de un mismo modulo (8 instancias de fulladd)
//  Por lo que se utilizan 'parametros' para trabajar con n cantidades de bits
module addern (carryin, X, Y, S, carryout);
    parameter n = 32;

    input carryin;
    input [n– 1:0] X, Y;
    output reg [n –1:0] S;
    output reg carryout;
    reg [n:0] C;

    integer k;  // Variable 'entera' utilizada por el compilador
    always @(X, Y, carryin)
    begin
        C[0] = carryin;
        for (k = 0; k < n; k = k+1)
        begin
            S[k] = X[k] Y[k] C[k];
            C[k+1] = (X[k] & Y[k]) (X[k] & C[k]) (Y[k] & C[k]);
        end
        carryout = C[n];
    end
endmodule

// En este caso se instancia n-veces un modulo por medio del bloque 'generate'
// En este caso, cada instancia del modulo 'fulladd' sera renombrado addbit[k].stage
module addern (carryin, X, Y, S, carryout);
    parameter n = 64;
    
    input carryin;
    input [n –1:0] X, Y;
    output [n –1:0] S;
    output carryout;
    wire [n:0] C;

    genvar i;   // Tipo de variable similar a integer, pero unicamente positivo y utilizable solo en bloques generate
    assign C[0] = carryin;
    assign carryout = C[n];

    generate
        for (i = 0; i < = n –1; i = i+1)
        begin:addbit    // Aca se renombra cada instancia
            fulladd stage (C[i], X[i], Y[i], S[i], C[i+1]);
        end
    endgenerate
endmodule

// Claramente tiene que haber una forma mas facil, sin tener que instanciar n-veces un bloque, o array.
// Este sumador hace la suma vectorial de los array X e Y, tampoco incluye carry_out ya que solo tiene sentido
// cuando son numeros sin signo (ya que vale 1 cuando se produce un desborde de n bits)
module addern (carryin, X, Y, S);
    parameter n = 32;
    input carryin;
    input [n –1:0] X, Y;
    output reg [n –1:0] S;

    always @(X, Y, carryin)
        S = X + Y + carryin;
endmodule

// Pero si X, Y o S son numeros con signo, se deben implementar el carry y el overflow aparte
module addern (carryin, X, Y, S, carryout, overflow);
    parameter n = 32;

    input carryin;
    input [n– 1:0] X, Y;
    output reg [n– 1:0] S;
    output reg carryout, overflow;

    always @(X, Y, carryin)
    begin
        S = X + Y + carryin;
        carryout = (X[n– 1] & Y[n– 1]) | (X[n– 1] & S[n– 1]) | (Y[n– 1] & S[n– 1]);
        overflow = (X[n– 1] & Y[n– 1] & S[n– 1]) | ( X[n– 1] & Y[n– 1] & S[n– 1]);
    end
endmodule

// La verdad ya no entiendo bien esto...
module addern (carryin, X, Y, S, carryout, overflow);
    parameter n = 32;
    input carryin;
    input [n– 1:0] X, Y;
    output reg [n– 1:0] S;
    output reg carryout, overflow;
    reg [n:0] Sum;

    always @(X, Y, carryin)
    begin
        Sum = {1’b0, X} + {1’b0, Y} + carryin;
        S = Sum[n– 1:0];
        carryout = Sum[n];
        overflow = (X[n– 1] & Y[n– 1] & S[n– 1]) | ( X[n– 1] & Y[n– 1] & S[n– 1]);
    end
endmodule