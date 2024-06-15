`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 15:49:33
// Design Name: 
// Module Name: BTNC_signal_ctl
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


module BTNC_signal_ctl(clk, rst, pb, sign);
input clk, rst, pb;
output sign;
reg init_rst;
wire _1Hzclk;
wire db_out;
_1HzClk U0(.clk(clk), .rst(init_rst), .clk_out(_1Hzclk));
debounce_circuit U1(.clk(clk), .rst_n(init_rst), .pb_in(pb), .pb_debounced(db_out));
one_pulse U2(.trig(db_out), .clk(_1Hzclk), .rst_n(init_rst), .out_pulse(sign));

initial begin
init_rst = 1;
#1 init_rst = 0;
#1 init_rst = 1;
end


endmodule