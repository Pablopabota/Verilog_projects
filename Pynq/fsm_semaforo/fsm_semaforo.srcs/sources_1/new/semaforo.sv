//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 12:30:36 AM
// Design Name: 
// Module Name: semaforo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module semaforo (
    input wire clk,     // Reloj del sistema
    input wire rst,     // Reset activo en bajo
    input wire btn0,    // Botón
    output reg [2:0] color  // Salida RGB
);
    reg [1:0] state;
    reg [8:0] cnt;

    // === Sincronización del botón ===
    reg btn_sync_0, btn_sync_1, btn_prev;
    wire btn_pulse;

    always @(posedge clk) begin
        btn_sync_0 <= btn0;
        btn_sync_1 <= btn_sync_0;
        btn_prev <= btn_sync_1;
    end

    assign btn_pulse = (btn_sync_1 && ~btn_prev); // flanco de subida

    // === FSM con contador ===
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 0;
            cnt <= 0;
        end else if (btn_pulse) begin
            case (state)
                0: begin // Rojo
                    if (cnt == 10) begin
                        state <= 1;
                        cnt <= 0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                1: begin // Ambar
                    if (cnt == 2) begin
                        state <= 2;
                        cnt <= 0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                2: begin // Verde
                    if (cnt == 8) begin
                        state <= 0;
                        cnt <= 0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
            endcase
        end
    end

    // === Salidas de color ===
    always @(*) begin
        case(state)
            0: color = 3'b100; // Rojo
            1: color = 3'b011; // Ambar
            2: color = 3'b010; // Verde
            default: color = 3'b000;
        endcase
    end
endmodule
