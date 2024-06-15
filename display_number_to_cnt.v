`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 23:25:59
// Design Name: 
// Module Name: display_number_to_cnt
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


module display_number_to_cnt(
     input [15:0] display_number,
     output [3:0] cnt3,  
     output [3:0] cnt2,  
     output [3:0] cnt1,  
     output [3:0] cnt0   
    );
    
    assign cnt3 = display_number[15:12];
    assign cnt2 = display_number[11:8];
    assign cnt1 = display_number[7:4];
    assign cnt0 = display_number[3:0];
    
endmodule
