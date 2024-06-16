`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 15:22:24
// Design Name: 
// Module Name: Divider
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


module Divider(clk, rst, div, clk_out);
input clk, rst;
input [26:0]div;
output reg clk_out;

reg [26:0]cnt;

always @(posedge clk or negedge rst)
    if (~rst)
        cnt <= 1;
    else if (cnt == div)
        cnt <= 1;
    else
        cnt <= cnt + 1;
       
always @(posedge clk or negedge rst)
    if (~rst)
        clk_out <= 0;
    else if (cnt == div)
        clk_out <= ~clk_out;
    else
        clk_out <= clk_out;       

endmodule
