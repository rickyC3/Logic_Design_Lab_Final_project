`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 21:36:12
// Design Name: 
// Module Name: _1HzClk
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


module _1HzClk(clk, rst, clk_out);
input clk, rst;
output reg clk_out;

reg [26:0]cnt;

always @(posedge clk or negedge rst)
    if (~rst) begin
        clk_out <= 0;
        cnt <= 1;
    end else if (cnt == 27'd50000000) begin
        clk_out <= ~clk_out;
        cnt <= 1;
    end else begin
        clk_out <= clk_out;
        cnt <= cnt + 1;
    end
        
endmodule
