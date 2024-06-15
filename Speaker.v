`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 15:24:35
// Design Name: 
// Module Name: Speaker
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
`define Div_Do 27'd191571
`define Div_Re 27'd170648
`define Div_Mi 27'd151515
`define Div_Fa 27'd143266
`define Div_So 27'd127551
`define Div_La 27'd113636
`define Div_Si 27'd101214
`define Div_m_Do 27'd45086
`define Div_m_Re 27'd47081
`define Div_m_Mi 27'd50607
`define Div_m_Fa 27'd56818
`define Div_m_So 27'd63776
`define Div_m_La 27'd71633
`define Div_m_Si 27'd75758
`define Div_H_Do 27'd85034
`define Div_H_Re 27'd95420

module Speaker(clk, rst, Event, shoot_sign, MCLK, SCK, LRCK, Stdin);
input clk, rst;
output MCLK, LRCK, SCK, Stdin;
input [3:0]Event;
input shoot_sign;

reg init_rst;
reg [26:0]div_note_left, div_note_right;
reg [91:0]play_div;
reg [3:0]div_num, div_num2; 
reg [26:0]now_div; // background music
reg [26:0]now_div2;
wire [15:0]right_audio;
wire [15:0]left_audio;

wire clk_Hz;

_1HzClk OneHzClk(.clk(clk), .rst(rst), .clk_out(clk_Hz));
    

Buzzer Buzzer0(.clk(clk), .rst(rst), .right_div(div_note_right), .left_div(div_note_left), 
      .audio_right(right_audio), .audio_left(left_audio));


Speaker_CTL Speaker_CTL0(.clk(clk), .rst(rst), .left_audio(left_audio), .Stdin(Stdin),
            .right_audio(right_audio), .MCLK(MCLK), .LRCK(LRCK), .SCK(SCK));



always @*
      case(div_num)
            4'h0: now_div = `Div_Do;
            4'h1: now_div = `Div_Re;
            4'h2: now_div = `Div_Mi;
            4'h3: now_div = `Div_Fa;
            4'h4: now_div = `Div_So;
            4'h5: now_div = `Div_Re;
            4'h6: now_div = `Div_Si;
            4'h7: now_div = `Div_m_Do;
            4'h8: now_div = `Div_m_Re;
            4'h9: now_div = `Div_m_Mi;
            4'hA: now_div = `Div_m_Fa;
            4'hB: now_div = `Div_m_So;
            4'hC: now_div = `Div_m_Re;
            4'hD: now_div = `Div_m_Si;
            4'hE: now_div = `Div_H_Do;
            4'hF: now_div = `Div_H_Re;
			default: now_div = 27'd1;
	endcase

always @*
      case(div_num2)
            4'h0: now_div2 = `Div_Do;
            4'h1: now_div2 = `Div_Re;
            4'h2: now_div2 = `Div_Mi;
            4'h3: now_div2 = `Div_Fa;
            4'h4: now_div2 = `Div_So;
            4'h5: now_div2 = `Div_Re;
            4'h6: now_div2 = `Div_Si;
            4'h7: now_div2 = `Div_m_Do;
            4'h8: now_div2 = `Div_m_Re;
            4'h9: now_div2 = `Div_m_Mi;
            4'hA: now_div2 = `Div_m_Fa;
            4'hB: now_div2 = `Div_m_So;
            4'hC: now_div2 = `Div_m_Re;
            4'hD: now_div2 = `Div_m_Si;
            4'hE: now_div2 = `Div_H_Do;
            4'hF: now_div2 = `Div_H_Re;
			default: now_div2 = 27'd1;
	endcase

// background music
reg [91:0]b_music = 92'h223455442001102211000;


always @(posedge clk_Hz or negedge rst)
	if (~rst)
		play_div <= b_music;
	else
		play_div <= {play_div[87:0], play_div[91:88]};

always @* begin
	div_num = play_div[91:88];
    div_num2 = play_div[3:0];
end

always @* begin
	div_note_left = now_div;
	
	if (Event[0])
		div_note_right = `Div_m_Do;
	else if (shoot_sign)
		div_note_right = `Div_Re;
	else 
		div_note_right = now_div2;end	

endmodule