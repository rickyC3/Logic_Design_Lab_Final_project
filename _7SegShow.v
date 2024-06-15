`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/30 16:46:13
// Design Name: 
// Module Name: _7SegShow
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
`define SS_0 8'b00000011
`define SS_1 8'b10011111
`define SS_2 8'b00100101
`define SS_3 8'b00001101
`define SS_4 8'b10011001
`define SS_5 8'b01001001
`define SS_6 8'b01000001
`define SS_7 8'b00011111
`define SS_8 8'b00000001
`define SS_9 8'b00001001

module _7SegShow(clk, rst, cnt3, cnt2, cnt1, cnt0, ssd_out, D);
input clk, rst;
input [3:0]cnt3;
input [3:0]cnt2;
input [3:0]cnt1;
input [3:0]cnt0;

output reg [3:0]ssd_out;
output reg [7:0]D;
wire [1:0]clk_ctl;
wire flash_clk;
reg [3:0]ssd;
reg [3:0]show_cnt;


_7SegShow_ctl ShowCtl0(.clk(clk), .rst(rst), .clk_out(clk_ctl));

always @*
    case(clk_ctl)
        2'b00: begin ssd = 4'b1110; show_cnt = cnt0;end
        2'b01: begin ssd = 4'b1101; show_cnt = cnt1;end
        2'b10: begin ssd = 4'b1011; show_cnt = cnt2;end
        2'b11: begin ssd = 4'b0111; show_cnt = cnt3;end
        default: begin ssd = 4'b1111; show_cnt = 4'b1111;end
    endcase

always @*
    case(show_cnt)
        4'd0: D = `SS_0;
        4'd1: D = `SS_1;
        4'd2: D = `SS_2;
        4'd3: D = `SS_3;
        4'd4: D = `SS_4;
        4'd5: D = `SS_5;
        4'd6: D = `SS_6;
        4'd7: D = `SS_7;
        4'd8: D = `SS_8;
        4'd9: D = `SS_9;
        default: D = 8'b11111110;
    endcase
    
always @*
    ssd_out = ssd;

endmodule
