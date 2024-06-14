`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 22:17:40
// Design Name: 
// Module Name: Top
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


module Top(clk, rst, h_sync, v_sync, vga_red, vga_green, vga_blue, move_sw, cd_led, pb_c, act_cd_state);
input clk, rst;
input pb_c;
input [3:0]move_sw;
output [1:0]act_cd_state; // for debug
output [3:0]vga_red, vga_green, vga_blue;
output cd_led;
wire clk_1Hz; // 1 sec
wire clk_22, clk_25MHz; // 100 / 2^22 Hz

// score
integer score;

// dragon move
wire [9:0]d_x, d_y;
wire dragon_valid;


// robot
wire [9:0]r_x, r_y;
wire robot_valid;

// robot
wire [9:0]m_x, m_y;
wire missile_valid;

// vga ctl
wire vga_valid;
wire [9:0]h_cnt, v_cnt;
output h_sync, v_sync;

wire [11:0]Pixel;
wire [1:0]Event;
assign {vga_red, vga_green, vga_blue} = (vga_valid)? Pixel:12'h0;
    

_1HzClk _1HzClk_U0(.clk(clk), .rst(rst), .clk_out(clk_1Hz));
Clk_22 Clk_22_U0(.clk(clk), .rst(rst), .clk_out_22(clk_22), .clk_out_25(clk_25MHz));

Dragon_move Dragon_Move_U0(.clk_1Hz(clk_1Hz), .clk_22(clk_22), 
     .rst(rst), .d_x(d_x), .d_y(d_y), .show_valid(dragon_valid), .Event(Event));

Robot_move Robot_move_U0(.clk_1Hz(clk_1Hz), .clk_22(clk_22), .rst(rst), 
.r_x(r_x), .r_y(r_y), .move_opr(move_sw), .show_valid(robot_valid), .Event(Event));

Missile_move Missile_move_U0(.clk_1Hz(clk_1Hz), .clk_22(clk_22), .rst(rst), .shoot_sign(pb_c),
.r_x(r_x), .r_y(r_y), .m_x(m_x), .m_y(m_y), .show_valid(missile_valid), .cd_sign(cd_led), .act_cd_state(act_cd_state));

vga_controller  vga_inst(
  .pclk(clk_25MHz),
  .reset(rst),
  .hsync(h_sync),
  .vsync(v_sync),
  .valid(vga_valid),
  .h_cnt(h_cnt),
  .v_cnt(v_cnt)
);

mem_gen Dragon_mem_gen(.clk_25Hz(clk_25MHz), .clk_22(clk_22), .rst(rst), .dragon_valid(dragon_valid), 
.h_cnt(h_cnt), .v_cnt(v_cnt), .d_x(d_x), .d_y(d_y), .r_x(r_x), .r_y(r_y),
.m_x(m_x), .m_y(m_y), .Pixel(Pixel), .Event(Event), 
.d_valid(dragon_valid), .r_valid(robot_valid), .m_valid(missile_valid));

always @(posedge clk_22 or negedge rst)
    if (~rst)
        score <= 0;
    else if (Event[1])
        score <= score + 1;
    else
        score <= score;



endmodule
