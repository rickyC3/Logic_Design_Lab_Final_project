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


module Dragon_move(clk_22, rst, pause, d_x, d_y, show_valid, life_state, init);
input clk_22, rst, pause;
input [9:0]init;
input life_state; // d, r die
output reg [9:0]d_x, d_y; // now poition, with left up
output reg show_valid;

reg alive = 1; // 1: alive, 0: dead 
integer cd_cnt; // 10 sec;
reg reborn_sign;

reg [9:0]dx, dy;

wire [9:0]re_pos_x;
wire [9:0]re_pos_y;
wire [9:0]direction;

// from right up to down left
always @* begin
    
    
    show_valid = alive;
end

LFSR reborn_pos_x(.clk_22(clk_22), .rst(rst), .init(init+10'h89), .num(re_pos_x));
LFSR reborn_pos_y(.clk_22(clk_22), .rst(rst), .init(init), .num(re_pos_y));

LFSR dir(.clk_22(clk_22), .rst(rst), .init(init+10'h50), .num(direction));


always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        d_x <= (init % 200) + 450; // init poition
        d_y <= (init % 320) + 160;
    end else if (pause) begin
        d_x <= d_x;
        d_y <= d_y;
    end else if (~alive) begin // touch board
        d_x <= (re_pos_x % 200) + 450; // back to begin
        d_y <= (re_pos_y % 320) + 160;
    end else if (direction[0]) begin
        d_x <= d_x - 10'd5;//- dx;// notice to dec or increase sign
        d_y <= d_y + 10'd5; //+ dy;
    end else if (~direction[0]) begin
        d_x <= d_x - 10'd5;
        d_y <= d_y - 10'd5;
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
    end else if (life_state) begin
        alive <= 0;
        cd_cnt <= 0;
    end else begin
        alive <= alive;
        cd_cnt <= cd_cnt;
    end
        



endmodule
