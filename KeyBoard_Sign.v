`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 20:13:17
// Design Name: 
// Module Name: KeyBoard_Sign
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


module KeyBoard_Sign(ps2_data, ps2_clk, rst_p, clk_100Hz, move_opr, shoot_sign);
inout ps2_data, ps2_clk;
input rst_p, clk_100Hz;
output reg [3:0]move_opr;
output reg shoot_sign;

wire [511:0]key_down;
wire [8:0]last_change;
wire key_valid;

reg [511:0]key_decoder;
reg [511:0]key_tmp;
reg key_state;

reg w_key_state, a_key_state, s_key_state, d_key_state, space_state; // 29
reg [511:0]w_decoder, a_decoder, s_decoder, d_decoder, sp_decoder;

// key detect
always @* begin
// https://electronics.stackexchange.com/questions/447795/how-to-specify-a-value-for-each-bit-of-the-reg-in-verilog
// https://nandland.com/reduction-operators/    
    key_decoder = 1 << last_change;
    key_tmp = (key_down & key_decoder);
    key_state = |key_tmp;
end


    KeyboardDecoder( .key_down(key_down), .last_change(last_change), 
                 .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), 
                 .rst(~rst_p), .clk(clk_100Hz));


always @* begin
    w_decoder = (1 << 8'h1D);
    w_key_state = |(key_down & (1 << 8'h1D));// check w in key_down 
    
    a_decoder = (1 << 8'h1C);
    a_key_state = |(key_down & (1 << 8'h1C));// check a in key_down
    
    s_decoder = (1 << 8'h1B);
    s_key_state = |(key_down & (1 << 8'h1B));// check s in key_down
    
    d_decoder = (1 << 8'h23);
    d_key_state = |(key_down & (1 << 8'h23));// check d in key_down
    
    sp_decoder = (1 << 8'h29);
    space_state = |(key_down & (1 << 8'h29));// check space in key_down

    shoot_sign = space_state; // move opration
    move_opr = {w_key_state, s_key_state, a_key_state, d_key_state}; // space(fire) signal
end

endmodule

