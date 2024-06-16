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


module Missile_move(clk_22, pause, rst, r_x, r_y, m_x, m_y, show_valid, cd_sign, shoot_sign, act_cd_state);
input clk_22, rst, shoot_sign, pause;
input [9:0]r_x, r_y;      // robot's pos
output reg [9:0]m_x, m_y; // now poition, with left up
output reg show_valid;    // if not in shootind mode(act_cd_state == 2'b01) --> not show.
output reg cd_sign;       // reload time


output reg [1:0]act_cd_state; 
// 3 status: 00: ready to fire, 01: firing, 10: reload(cd). No 11 states.

integer cd_cnt; // 10 ;

// from right up to down left
always @* begin  
    show_valid = (act_cd_state == 2'b01)? 1:0;
    cd_sign = (act_cd_state == 2'b10)? 1:0;// in cd status
end


always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        m_x <= 10'd100; // init poition
        m_y <= 10'd140;
    end else if (pause) begin // if pause, don't move;
        m_x <= m_x;
        m_y <= m_y;
    end else if (act_cd_state != 2'b01) begin // not in firing status
        m_x <= r_x; // move with robot
        m_y <= r_y;
    end else if (act_cd_state == 2'b01)begin // firing, move to right umtil touch the board
        m_x <= m_x + 10'd50; // fast speed
        m_y <= m_y;
    end


always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        act_cd_state <= 2'b00;// init, no fire
    end else if (pause) begin // pause, maintain to right now staus
        act_cd_state <= act_cd_state;
        cd_cnt <= cd_cnt;
    end else if (act_cd_state == 2'b11) begin // avoid error status
        act_cd_state <= 2'b00;
    end else if (act_cd_state == 2'b10 && cd_cnt == 10) begin
    // reload done, back to ready to fire status.
        act_cd_state <= 2'b00;
        cd_cnt <= 0;
    end else if (act_cd_state == 2'b10) begin // else, still in reload status
        act_cd_state <= act_cd_state;
        cd_cnt <= cd_cnt + 1; //  contiu. count
    // if it's in firing staus and touch board --> end firing status, into reload status
    end else if (act_cd_state == 2'b01 && m_x < 3 || m_x >= 640 || m_y < 3 || m_y >= 480) begin // touch board
        act_cd_state <= 2'b10;
        cd_cnt <= 0;
    end else if (act_cd_state == 2'b01) begin // maintain in firing status
        act_cd_state <= act_cd_state;
        cd_cnt <= 0;
    end else if (shoot_sign && act_cd_state == 2'b00) begin // active missile
        act_cd_state <= 2'b01;
        cd_cnt <= cd_cnt;
    end else if (act_cd_state == 2'b00)begin // maintain in unactive status(ready to fire status)
        act_cd_state <= 2'b00;
        cd_cnt <= cd_cnt;
    end else begin
        act_cd_state <= act_cd_state;
        cd_cnt <= cd_cnt;
    end    

endmodule