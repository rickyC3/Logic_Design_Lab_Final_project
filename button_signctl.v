`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/15 11:48:45
// Design Name: 
// Module Name: button_signctl
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


module button_signctl(clk ,rst, pb, sign);
input clk, rst, pb;
output sign;

wire _1HzClk;
wire db_out;

_1HzClk Oneclk(.clk(clk), .rst(rst), .clk_out(_1HzClk));
debounce_circuit Debounce(.clk(clk), .rst_n(rst), .pb_in(pb), .pb_debounced(db_out));
one_pulse OnePulse(.clk(_1HzClk), .rst_n(rst), .trig(db_out), .out_pulse(sign));

endmodule

