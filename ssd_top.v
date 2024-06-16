`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 15:43:26
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


module ssd_top(
    input clk,
    input rst,
    input pause,         //dip switch signal for pause/resume
    input pb_center,       //pb signal for sssd display changing
    input [15:0] pts,      //points you get now
    input [15:0] hpts,     //highest points you got
    input [15:0] rounds,   //the round you are playing now
    output [3:0] ssd_out,
    output [7:0] D,
    output [1:0] now_state,
    output stop_state
    );

    
    wire pb_signal;  //the signal from the button
    wire [3:0] cnt0, cnt1, cnt2, cnt3;
    wire [15:0] display_number;  //which number of the state should display 
    wire [15:0] times;  //how long you played this game
    wire [15:0] time_out;  //check for 59:59

    // Timer(clk, rst, pause, times, time_out, stop_state, stop);
    Timer TTO(.clk(clk), .rst(rst), .pause(pause), .times(times), 
                         .time_out(time_out), .stop_state(stop_state));
    
    BTNC_signal_ctl pb_c_signal_ctl0(.clk(clk), .rst(rst), .pb(pb_center), .sign(pb_signal));
    FSM F_S_M0(.rst(rst), .clk(clk), .short_signal(pb_signal), .display_number(display_number), 
                       .pts(pts), .hpts(hpts), .times(times), .rounds(rounds), .state(now_state));
    display_number_to_cnt DNTC0(.display_number(display_number), .cnt0(cnt0), .cnt1(cnt1), .cnt2(cnt2), .cnt3(cnt3));
    _7SegShow SSD0(.clk(clk), .rst(rst), .cnt0(cnt0), .cnt1(cnt1), .cnt2(cnt2), .cnt3(cnt3), .ssd_out(ssd_out), .D(D));


      
    
endmodule
