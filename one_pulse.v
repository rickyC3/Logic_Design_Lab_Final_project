`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/13 14:01:06
// Design Name: 
// Module Name: one_pulse
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


module one_pulse(trig, clk, rst_n, out_pulse);
input trig;
input clk;
input rst_n;
output reg out_pulse;
reg trig_del; // trig_delay 
reg nxt_pulse;

always @*
    nxt_pulse = trig & (~trig_del);

always @(posedge clk or negedge rst_n)
    if (~rst_n)
        trig_del <= 0;
    else
        trig_del <= trig;
      
always @(posedge clk or negedge rst_n)
    if (~rst_n)
        out_pulse <= 0;
    else
        out_pulse <= nxt_pulse;
        

endmodule
