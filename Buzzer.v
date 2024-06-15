`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 15:23:41
// Design Name: 
// Module Name: Buzzer
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


module Buzzer(clk, rst, right_div, left_div, audio_right, audio_left);
input clk, rst;
input [26:0]right_div;
input [26:0]left_div;
output [15:0]audio_right;
output [15:0]audio_left;

reg [26:0]cnt_right, cnt_left;
wire fre_div_left;
wire fre_div_right;

// right
Divider Divider_right(.clk(clk), .rst(rst), .div(right_div), .clk_out(fre_div_right));
// left
Divider Divider_left(.clk(clk), .rst(rst), .div(left_div), .clk_out(fre_div_left));

assign audio_left = (~fre_div_left)? 16'hde01:16'h21ff;
assign audio_right = (~fre_div_right)? 16'hde01:16'h21ff;


endmodule
