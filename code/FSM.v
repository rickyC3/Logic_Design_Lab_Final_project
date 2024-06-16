`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/12 16:14:41
// Design Name: 
// Module Name: FSM
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
`define STATE_1 2'b00  //the state for pts
`define STATE_2 2'b01  //the state for hpts
`define STATE_3 2'b10  //the state for times
`define STATE_4 2'b11  //the state for rounds

module FSM(
    input clk,
    input rst,
    input [15:0] pts,
    input [15:0] hpts,
    input [15:0] times,
    input [15:0] rounds,
    input short_signal,  //the signal of pb
    output reg [15:0] display_number,
    output reg [1:0] state
    );
    
    reg [1:0] next_state;
    wire one_Hzclk;  //one Hz clk signal
    
    _1HzClk OneClk0(.clk(clk), .rst(rst), .clk_out(one_Hzclk));
    
    always@(posedge one_Hzclk) begin
             case(state)
                 `STATE_1:
                       if (short_signal) begin
                          next_state = `STATE_2;
                       end
                       else begin
                          next_state = `STATE_1;
                       end
                 `STATE_2:
                       if (short_signal) begin
                          next_state = `STATE_3;
                       end
                       else begin
                          next_state = `STATE_2;
                       end   
                 `STATE_3:
                       if (short_signal) begin
                          next_state = `STATE_4;
                       end
                       else begin
                          next_state = `STATE_3;
                       end
                 `STATE_4:
                       if (short_signal) begin
                          next_state = `STATE_1;
                       end
                       else begin
                          next_state = `STATE_4;
                       end
            endcase
    end                                                                       
    
    always@(posedge clk or negedge rst)
          if (~rst)
            state <= `STATE_1;
          else
            state <= next_state;        
                      
    always@*
          case(state)
               2'b00 : begin display_number = pts;end
               2'b01 : begin display_number = hpts;end
               2'b10 : begin display_number = times;end
               2'b11 : begin display_number = rounds;end
               default: begin display_number = 16'b0;end
          endcase     
                                              
    
endmodule
