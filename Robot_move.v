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


module Robot_move(clk_1Hz, clk_22, rst, r_x, r_y, move_opr, show_valid, Event);
input clk_22, clk_1Hz, rst;
input [3:0]move_opr;
input [1:0]Event; // d, r die
output reg [9:0]r_x, r_y; // now poition, with left up
output reg show_valid;

reg alive = 1; // 1: alive, 0: dead 
integer cd_cnt; // 10 sec;
reg reborn_sign;
reg [9:0]tar_x = 10'd80;
reg [9:0]tar_y = 10'd420;
reg [9:0]r_nxt_x, r_nxt_y;

// from right up to down left
always @* begin  
    show_valid = alive;
end

always @*
    case(move_opr) // up, down, left, right
        4'b0000: begin r_nxt_x = r_x; r_nxt_y = r_y; end
        4'b0001: begin r_nxt_x = r_x + 10'd5; r_nxt_y = r_y; end
        4'b0010: begin r_nxt_x = r_x - 10'd5; r_nxt_y = r_y; end
        4'b0011: begin r_nxt_x = r_x; r_nxt_y = r_y; end
        4'b0100: begin r_nxt_x = r_x; r_nxt_y = r_y + 10'd5; end
        4'b0101: begin r_nxt_x = r_x + 10'd5; r_nxt_y = r_y + 10'd5; end
        4'b0110: begin r_nxt_x = r_x - 10'd5; r_nxt_y = r_y + 10'd5; end
        4'b0111: begin r_nxt_x = r_x; r_nxt_y = r_y + 10'd5; end
        4'b1000: begin r_nxt_x = r_x; r_nxt_y = r_y - 10'd5; end
        4'b1001: begin r_nxt_x = r_x + 10'd5; r_nxt_y = r_y - 10'd5; end
        4'b1010: begin r_nxt_x = r_x - 10'd5; r_nxt_y = r_y - 10'd5; end
        4'b1011: begin r_nxt_x = r_x; r_nxt_y = r_y - 10'd5; end
        4'b1100: begin r_nxt_x = r_x; r_nxt_y = r_y; end
        4'b1101: begin r_nxt_x = r_x + 10'd5; r_nxt_y = r_y; end
        4'b1110: begin r_nxt_x = r_x - 10'd5; r_nxt_y = r_y; end
        4'b1111: begin r_nxt_x = r_x; r_nxt_y = r_y; end
        default: begin r_nxt_x = r_x; r_nxt_y = r_y; end
    endcase
    
always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        r_x <= 10'd100; // init poition
        r_y <= 10'd140;
    end else if (~alive) begin // touch board
        r_x <= 10'd100; // back to begin
        r_y <= 10'd140;
    end else if (r_nxt_x < 3 || r_nxt_x >= 637 || r_nxt_y < 3 || r_nxt_y >= 477) begin // touch board
        r_x <= r_x;
        r_y <= r_y;
    end else begin
        r_x <= r_nxt_x;
        r_y <= r_nxt_y;
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
    end else if (Event[0]) begin
        alive <= 0;
        cd_cnt <= 0;
    end else begin
        alive <= alive;
        cd_cnt <= cd_cnt;
    end
        

endmodule