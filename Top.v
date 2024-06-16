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


module Top(clk, rst, pause, sw_t1, pb_c, ps2_data, ps2_clk, h_sync, v_sync, 
                    vga_red, vga_green, vga_blue, cd_led, act_cd_state,
                           ssd_out, D, now_state, stop_state, otk_led,
                               MCLK, SCK, LRCK, Stdin);
input clk, rst, pause, pb_c, sw_t1;
output MCLK, LRCK, SCK, Stdin;
inout ps2_data, ps2_clk;
output [1:0]act_cd_state; // for debug
output [3:0]vga_red, vga_green, vga_blue;
output cd_led;
output reg otk_led;
output [3:0]ssd_out;
output [7:0]D;
output [1:0]now_state;
output stop_state;
wire clk_1Hz; // 1 sec
wire clk_22, clk_25MHz; // 100 / 2^22 Hz

// score
reg [13:0]h_score, score, rounds;
wire [15:0]bcd_hscore, bcd_score, bcd_rounds;
// dragon move
wire [9:0]d_x, d_y;
wire dragon_valid;
// dragon1 move
wire [9:0]d1_x, d1_y;
wire dragon1_valid;
// dragon2 move
wire [9:0]d2_x, d2_y;
wire dragon2_valid;


// robot
wire [9:0]r_x, r_y;
wire robot_valid;
wire shoot_sign;
wire [3:0]move_opr;

// missile
wire [9:0]m_x, m_y;
wire missile_valid;

// vga ctl
wire vga_valid;
wire [9:0]h_cnt, v_cnt;
output h_sync, v_sync;

wire [11:0]Pixel;
wire [3:0]Event;

wire otk_sign;

assign {vga_red, vga_green, vga_blue} = (vga_valid)? Pixel:12'h0;
    

_1HzClk _1HzClk_U0(.clk(clk), .rst(rst), .clk_out(clk_1Hz));
Clk_22 Clk_22_U0(.clk(clk), .rst(rst), .clk_out_22(clk_22), .clk_out_25(clk_25MHz));

Dragon_move Dragon_Move_U0( .clk_22(clk_22), .init(10'hAB), .pause(pause),
     .rst(rst), .d_x(d_x), .d_y(d_y), .show_valid(dragon_valid), .life_state(Event[3]));

Dragon_move Dragon_Move_U1( .clk_22(clk_22), .init(10'h27), .pause(pause),
     .rst(rst), .d_x(d1_x), .d_y(d1_y), .show_valid(dragon1_valid), .life_state(Event[2]));

Dragon_move Dragon_Move_U2( .clk_22(clk_22), .init(10'h43), .pause(pause),
     .rst(rst), .d_x(d2_x), .d_y(d2_y), .show_valid(dragon2_valid), .life_state(Event[1]));

Robot_move Robot_move_U0(.pause(pause), .clk_22(clk_22), .rst(rst), 
.r_x(r_x), .r_y(r_y), .move_opr(move_opr), .show_valid(robot_valid), .Event(Event));

Missile_move Missile_move_U0(.pause(pause), .clk_22(clk_22), .rst(rst), .shoot_sign(shoot_sign),
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

mem_gen Dragon_mem_gen(.clk_25Hz(clk_25MHz), .clk_22(clk_22), .sw_in_t1(sw_t1), .rst(rst), 
.h_cnt(h_cnt), .v_cnt(v_cnt), .d_x(d_x), .d_y(d_y), .r_x(r_x), .r_y(r_y), .d1_x(d1_x), .d1_y(d1_y), .d2_x(d2_x), .d2_y(d2_y),
.m_x(m_x), .m_y(m_y), .pixel(Pixel), .Event(Event), 
.d_valid(dragon_valid), .r_valid(robot_valid), .m_valid(missile_valid), 
.d1_valid(dragon1_valid), .d2_valid(dragon2_valid), .otk_sign(otk_sign));

KeyBoard_Sign(.ps2_data(ps2_data), .ps2_clk(ps2_clk), .rst_p(rst), 
.clk_100Hz(clk), .move_opr(move_opr), .shoot_sign(shoot_sign));

Speaker(.clk(clk), .rst(rst), .Event(Event), .shoot_sign(shoot_sign), 
         .MCLK(MCLK), .SCK(SCK), .LRCK(LRCK), .Stdin(Stdin));

// turn binary code to BCD code
INT2BCD score_BCD(.int(score), .bcd(bcd_score));
INT2BCD hscore_BCD(.int(h_score), .bcd(bcd_hscore));
INT2BCD rounds_BCD(.int(rounds), .bcd(bcd_rounds));

ssd_top(
.clk(clk),
.rst(rst),
.pause(pause),         //dip switch signal for pause/resume
.pb_center(pb_c),       //pb signal for sssd display changing
.pts(bcd_score),      //points you get now
.hpts(bcd_hscore),     //highest points you got
.rounds(bcd_rounds),   //the round you are playing 
.ssd_out(ssd_out),
.D(D),
.now_state(now_state),
.stop_state(stop_state)
    );
    


always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        score <= 0;
        h_score <= 0;end
    else if (Event[0]) 
        score <= 0;
    else if (Event[1] || Event[2] || Event[3]) begin // if any dragon die 
                
        case(Event[3:1]) // add the points by each condition
            3'b001, 3'b010, 3'b100: begin score <= score + 1; h_score <= (score + 1 > h_score)? score + 1:h_score; end
            3'b011, 3'b110, 3'b101: begin score <= score + 2; h_score <= (score + 2 > h_score)? score + 2:h_score; end
            3'b111: begin score <= score + 3; h_score <= (score + 3 > h_score)? score + 3:h_score; end
            default: score <= score;
        endcase
        
        
    end else
        score <= score;

always @(posedge clk_22 or negedge rst) // if robot die --> new rounds
    if (~rst)
        rounds <= 0;
    else if (Event[0])
        rounds <= rounds + 1;
    else
        rounds <= rounds;
        
always @(posedge clk_1Hz or negedge rst)
    if (~rst)
        otk_led <= 0;
    else if (otk_sign)
        otk_led <= ~otk_led;
    else if (~otk_sign)
        otk_led <= 0;
    else
        otk_led <= otk_led;

    

endmodule
