`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 21:28:53
// Design Name: 
// Module Name: Clk_22
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


module Clk_22(clk, rst, clk_out_22, clk_out_25);
input clk, rst;
output reg clk_out_22, clk_out_25;

reg [20:0]cnt;

always @(posedge clk or negedge rst) // check pos or neg
    if (~rst)
        {clk_out_22, cnt} <= 0;
    else
        {clk_out_22, cnt} <= {clk_out_22, cnt} + 1;
        
always @*
    clk_out_25 = cnt[1];


endmodule
