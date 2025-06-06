// Entradas: 
// clk – clock, reset (1 bit), 
// PW – Processor Write (1 bit), 
// PR – Processor Read (1 bit), 
// BW – Bus Write (1 bit), 
// BR – Bus Read (1 bit),
// S – Shared (1 bit).

// Salida: state (2 bits):
// o 00’b: Modified
// o 01’b: Exclusive
// o 10’b: Shared
// o 11’b: Invalid

module mesi_fsm (
    // Señales de entrada
    input clk, pw, pr, bw, br, s,
    input rst,

    // Señales de salida
    output reg [1:0] state
);

    //  Señales internas
    reg [2:0] cur_e;    // Estado actual
    reg [2:0] fut_e;    // Estado siguiente

    // Constantes
    parameter M = 2'b00, E = 2'b01, S = 2'b11, I = 2'b10;

    // Logica de siguiente estado
    always @(*) begin
        case(cur_e)
            M: begin
                fut_e <= br? S : bw? I : M;
            end
            E: begin
                fut_e <= br? S : bw? I : pw? M : E;
            end
            S: begin
                fut_e <= bw? I : pw? E : S;
            end
            I: begin
                fut_e <= (pr && s)? S : (pr && ~s)? E : pw? E : I;
            end
            default: fut_e = I;
        endcase
    end

    // Aplico el cambio de estado
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            cur_e <= I;
        end
        else begin
            cur_e <= fut_e;
        end
    end

    // Logica de salida
    always @(*) begin
        case (cur_e)
            M: begin
                state <= cur_e;
            end
            E: begin
                state <= cur_e;
            end
            S: begin
                state <= cur_e;
            end
            I: begin
                state <= cur_e;
            end
            default: begin
                state <= I;                
            end
        endcase
    end

endmodule