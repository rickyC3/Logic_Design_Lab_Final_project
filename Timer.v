`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/04 11:59:42
// Design Name: 
// Module Name: lab05_3_top
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


module Timer(clk, rst, pause, times, time_out, stop_state);
input clk, rst;
input pause;
output [15:0]times;
output [15:0]time_out;


reg init_rst;
wire _OneHz;
//output 
output reg stop_state = 1;

_1HzClk OneClk1(.clk(clk), .rst(init_rst), .clk_out(_OneHz));

BCD_ctl T0(.clk(clk), 
.init_rst(init_rst), .rst(rst), 
.stop(stop_state), .setting(1), 
.times(times), .time_out(time_out)); // times_out no use

always @*
    stop_state = pause;


    
initial begin
init_rst = 1;
#1 init_rst = 0;
#1 init_rst = 1;
end

endmodule
