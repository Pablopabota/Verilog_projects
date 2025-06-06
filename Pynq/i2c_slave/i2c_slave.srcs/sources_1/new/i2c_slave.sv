//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 12:24:34 AM
// Design Name: 
// Module Name: i2c_slave
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

module i2c_slave #(
    parameter SLAVE_ADDR = 7'b1010000
 )(
    input  logic clk,
    input  logic rst,
    input  logic i2c_scl,
    inout  tri   i2c_sda,
    output logic [7:0] received_data,
    output logic data_valid
 );
    // Aqui va tu implementacion
 endmodule
