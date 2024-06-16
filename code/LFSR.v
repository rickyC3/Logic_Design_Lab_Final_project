`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 17:44:54
// Design Name: 
// Module Name: LFSR
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


module LFSR(clk_22, rst, init, num); // 0~511
input clk_22, rst;
input [9:0]init;
output reg [9:0]num;

always @(posedge clk_22 or negedge rst)
    if(~rst)
        num <= init;
    else begin
        num[9:1] <= num[8:0];
        num[0] <= (num[3]^num[4]^num[1]^num[7]);
    end
    
endmodule
