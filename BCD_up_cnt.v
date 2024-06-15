module BCD_up_cnt(clk, init_rst, rst, stop, setting, opr, init, min, max, cnt);
input clk, rst, stop, init, init_rst;
input setting; // 1, inc; 0, dec
input [3:0]min;
input [3:0]max;
output reg [3:0]cnt;
output reg opr;

always @*
    if (setting == 0 && cnt == min) // dec
        opr = 1;
    else if (setting == 1 && cnt == max)
        opr = 1;
    else
        opr = 0;
// setting, stop
always @(posedge clk or negedge rst)
    if (~init_rst || ~rst)
        cnt <= 0;
    else if (stop == 0 && setting == 0 && cnt == min) // dec
        cnt <= max;
    else if (stop == 0 && setting == 0)
        cnt <= cnt - 1;
    else if (stop == 0 && setting == 1 && cnt == max) // inc
        cnt <= min;
    else if (stop == 0 && setting == 1)
        cnt <= cnt + 1;
    else
        cnt <= cnt;



endmodule
