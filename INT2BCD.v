`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/15 19:59:37
// Design Name: 
// Module Name: INT2BCD
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


module INT2BCD(int, bcd);
input [13:0]int;
output reg [15:0]bcd;

always @* begin
    bcd[3:0] = int % 10;
    bcd[7:4] = (int / 10) % 10;
    bcd[11:8] = (int / 100) % 10;
    bcd[15:12] = (int / 1000);
end

endmodule
