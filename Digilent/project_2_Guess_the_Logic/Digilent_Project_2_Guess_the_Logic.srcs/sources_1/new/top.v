`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 09:16:19 PM
// Design Name: 
// Module Name: top
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


module top(
    input [7:0] sw,
    output [2:0] led
    );
    
assign led[0] = (sw[0] & ~sw[1]) | (~sw[0] & sw[1]);
assign led[1] = (~sw[3] & ~sw[2] & ~sw[1]) | (~sw[3] & sw[2] & sw[1]) | (sw[3] & ~sw[2] & sw[1]);
assign led[2] = (~sw[7] & ~sw[6] & ~sw[5] & sw[4]) | (~sw[7] & ~sw[6] & sw[5] & sw[4]) | 
                (~sw[7] & sw[6] & ~sw[5] & ~sw[4]) | (sw[7] & sw[6] & sw[5] & sw[4]);

endmodule
