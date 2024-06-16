module BCD_ctl(clk, init_rst, setting, rst, stop, times, time_out);
input clk, init_rst, rst, stop, setting;
output reg [15:0]times;
output reg [15:0]time_out = 0;


wire _1Hzclk;
wire sec_opr0;
wire [3:0]sec_cnt0;
wire sec_opr1;
wire [3:0]sec_cnt1;

wire min_opr0;
wire [3:0]min_cnt0;
wire min_opr1;
wire [3:0]min_cnt1;

reg stop0, stop1, stop2, stop3;

_1HzClk OneHz0(.clk(clk), .rst(init_rst), .clk_out(_1Hzclk));
// sec
BCD_up_cnt Sec0(.clk(_1Hzclk), .init_rst(init_rst), .rst(rst), .stop(stop0), .setting(setting), .opr(sec_opr0), .init(0), .min(0), .max(9), .cnt(sec_cnt0));
BCD_up_cnt Sec1(.clk(_1Hzclk), .init_rst(init_rst), .rst(rst), .stop(stop1), .setting(setting), .opr(sec_opr1), .init(0), .min(0), .max(5), .cnt(sec_cnt1));

// min
BCD_up_cnt Min0(.clk(_1Hzclk), .init_rst(init_rst), .rst(rst), .stop(stop2), .setting(setting), .opr(min_opr0), .init(0), .min(0), .max(9), .cnt(min_cnt0));
BCD_up_cnt Min1(.clk(_1Hzclk), .init_rst(init_rst), .rst(rst), .stop(stop3), .setting(setting), .opr(min_opr1), .init(0), .min(0), .max(5), .cnt(min_cnt1));



always @* begin
    if (sec_cnt0 == 4'b1001 && sec_cnt1 == 4'b0101 && min_cnt0 == 4'b1001 && min_cnt1 == 4'b0101) begin
        stop0 = 1;
    end else begin
        stop0 = stop;
    end
        
    stop1 = stop0 | ~sec_opr0;             
end

always @* begin 
    stop2 = stop1 | ~sec_opr1;
        
    stop3 = stop2 | ~min_opr0;             
end

always @*
    if (sec_cnt0 == 4'b1001 && sec_cnt1 == 4'b0101 && min_cnt0 == 4'b1001 && min_cnt1 == 4'b0101 && ~setting)
        time_out = 16'b1111111111111111;
    else
        time_out = 0;

always @*
    times = {min_cnt1, min_cnt0, sec_cnt1, sec_cnt0};

    
endmodule