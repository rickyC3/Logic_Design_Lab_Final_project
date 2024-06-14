`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 21:28:36
// Design Name: 
// Module Name: Dragon_move
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


module Dragon_move(clk_1Hz, clk_22, rst, d_x, d_y, show_valid, Event);
input clk_22, clk_1Hz, rst;
input [1:0]Event; // d, r die
output reg [9:0]d_x, d_y; // now poition, with left up
output reg show_valid;

reg alive = 1; // 1: alive, 0: dead 
integer cd_cnt; // 10 sec;
reg reborn_sign;
reg [9:0]tar_x = 10'd80;
reg [9:0]tar_y = 10'd420;
reg [9:0]dx, dy;

// from right up to down left
always @* begin
    dx = 2;//(10'd560 - tar_x) >> 2; // move_cnt;
    dy = 2;//(tar_y - 10'd60) >> 2;
    
    show_valid = alive;
end

always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        d_x <= 10'd560; // init poition
        d_y <= 10'd60;
    end else if (~alive) begin // touch board
        d_x <= 10'd560; // back to begin
        d_y <= 10'd60;
    end else begin
        d_x <= d_x - 10'd2;//- dx;// notice to dec or increase sign
        d_y <= d_y + 10'd2; //+ dy;
    end


always @(posedge clk_22 or negedge rst)
    if (~rst)
        alive <= 1;
    else if (~alive && cd_cnt == 100) begin
        alive <= 1;
        cd_cnt <= 0;
    end else if (~alive) begin 
        alive <= 0;
        cd_cnt <= cd_cnt + 1; // rebotrn cnt
    end else if (d_x < 3 || d_x >= 640 || d_y < 3 || d_y >= 480) begin // touch board
        alive <= 0;
        cd_cnt <= 0;
    end else if (Event[1]) begin
        alive <= 0;
        cd_cnt <= 0;
    end else begin
        alive <= alive;
        cd_cnt <= cd_cnt;
    end
        



endmodule
