`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 15:20:38
// Design Name: 
// Module Name: Speaker_CTL
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


module Speaker_CTL(clk, rst, left_audio, right_audio, MCLK, LRCK, SCK, Stdin);
input clk, rst;
input [15:0]left_audio;
input [15:0]right_audio;

output MCLK, LRCK, SCK, Stdin;
reg Stdin;
reg [4:0]cnt;


Divider MCLK0(.clk(clk), .rst(rst), .div(27'd2), .clk_out(MCLK));
Divider LRCK0(.clk(clk), .rst(rst), .div(27'd256), .clk_out(LRCK));
Divider SCK0(.clk(clk), .rst(rst), .div(27'd8), .clk_out(SCK));


    

    always@*
        case (cnt)
            5'd1: Stdin = left_audio[15]; // MSB
            5'd2: Stdin = left_audio[14];
            5'd3: Stdin = left_audio[13];
            5'd4: Stdin = left_audio[12];
            5'd5: Stdin = left_audio[11];
            5'd6: Stdin = left_audio[10];
            5'd7: Stdin = left_audio[9];
            5'd8: Stdin = left_audio[8];
            5'd9: Stdin = left_audio[7];
            5'd10: Stdin = left_audio[6];
            5'd11: Stdin = left_audio[5];
            5'd12: Stdin = left_audio[4];
            5'd13: Stdin = left_audio[3];
            5'd14: Stdin = left_audio[2];
            5'd15: Stdin = left_audio[1];
            5'd16: Stdin = left_audio[0];
            5'd17: Stdin = right_audio[15];
            5'd18: Stdin = right_audio[14];
            5'd19: Stdin = right_audio[13];
            5'd20: Stdin = right_audio[12];
            5'd21: Stdin = right_audio[11];
            5'd22: Stdin = right_audio[10];
            5'd23: Stdin = right_audio[9];
            5'd24: Stdin = right_audio[8];
            5'd25: Stdin = right_audio[7];
            5'd26: Stdin = right_audio[6];
            5'd27: Stdin = right_audio[5];
            5'd28: Stdin = right_audio[4];
            5'd29: Stdin = right_audio[3];
            5'd30: Stdin = right_audio[2];
            5'd31: Stdin = right_audio[1];
            5'd0: Stdin = right_audio[0]; // LSB
            default: Stdin = 0;
        endcase
            
    always @(negedge SCK or negedge rst) // by negedge SCK
        if (~rst) 
            cnt <= 0;
        else
            cnt <= cnt + 1;
        
endmodule
