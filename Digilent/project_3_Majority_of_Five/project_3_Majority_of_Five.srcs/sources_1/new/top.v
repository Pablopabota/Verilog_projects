`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 09:47:54 PM
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
    input [4:0] sw,
    output led
    );
    
assign led = (sw[0] & sw[1] & sw[2]) | //ABC
         (sw[0] & sw[1] & sw[3]) | //ABD
         (sw[0] & sw[2] & sw[3]) | //ACD
         (sw[1] & sw[2] & sw[3]) | //BCD
         (sw[0] & sw[1] & sw[4]) | //ABE
         (sw[0] & sw[3] & sw[4]) | //ADE
         (sw[0] & sw[2] & sw[4]) | //ACE
         (sw[1] & sw[2] & sw[4]) | //BCE
         (sw[2] & sw[3] & sw[4]) | //CDE
         (sw[1] & sw[3] & sw[4]);  //BDE
             
endmodule
