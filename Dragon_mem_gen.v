`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/13 14:05:07
// Design Name: 
// Module Name: Dragon_mem_gen
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


module mem_gen(clk_25Hz, clk_22, rst, dragon_valid, h_cnt, v_cnt, d_x, d_y, r_x, r_y, m_x, m_y, 
                        Pixel, Event, d_valid, r_valid, m_valid);
input clk_25Hz, dragon_valid, clk_22, rst;
input [9:0]h_cnt, v_cnt;
input [9:0]d_x, d_y;
input [9:0]r_x, r_y;
input [9:0]m_x, m_y;
output reg [11:0]Pixel;
output reg [1:0]Event;
input d_valid, r_valid, m_valid;
// dragon_mem_gen
wire [11:0]d_data;
wire [11:0]d_pixel;
reg [11:0]d_pixel_addr;
reg [9:0]d_dx, d_dy;

// check in the range
reg d_range;
reg d_enable;

// ========================
// robot_mem_gen
wire [11:0]r_data;
wire [11:0]r_pixel;
reg [11:0]r_pixel_addr;
reg [9:0]r_dx, r_dy;

// check in the range
reg r_range;
reg r_enable;

// ========================
// missile_mem_gen
wire [11:0]m_data;
wire [11:0]m_pixel;
reg [11:0]m_pixel_addr;
reg [9:0]m_dx, m_dy;

// check in the range
reg m_range;
reg m_enable;


// -------------------------------
reg d_die, r_die;


always @* begin
    d_dx = h_cnt - d_x;
    d_dy = v_cnt - d_y;
    d_range = ((d_x <= h_cnt) & ((h_cnt - d_x) < 40) & (v_cnt >= d_y) & ((v_cnt - d_y) < 30));
    d_enable = (d_range & d_valid)? 1:0;
end

always @*
    d_pixel_addr = (d_enable)? ((d_dy*40 + d_dx) % 1200) : 12'd0;

blk_mem_gen_0 dragon_pixel0(
  .clka(clk_25Hz),
  .wea(0),
  .addra(d_pixel_addr),
  .dina(d_data[11:0]),
  .douta(d_pixel)
); 

// ----------------------------

always @* begin
    r_dx = h_cnt - r_x;
    r_dy = v_cnt - r_y;
    r_range = ((r_x <= h_cnt) & ((h_cnt - r_x) < 40) & (v_cnt >= r_y) & ((v_cnt - r_y) < 30));
    r_enable = (r_range & r_valid)? 1:0;
end

always @*
    r_pixel_addr = (r_enable)? ((r_dy*40 + r_dx) % 1200) : 12'd0;

blk_mem_gen_1_robot robot_pixel0(
  .clka(clk_25Hz),
  .wea(0),
  .addra(r_pixel_addr),
  .dina(r_data[11:0]),
  .douta(r_pixel)
);

// --------------------------

always @* begin
    m_dx = h_cnt - m_x;
    m_dy = v_cnt - m_y;
    m_range = ((m_x <= h_cnt) & ((h_cnt - m_x) < 56) & (v_cnt >= m_y) & ((v_cnt - m_y) < 12));
    m_enable = (m_range & m_valid)? 1:0;
end

always @*
    m_pixel_addr = (m_enable)? ((m_dy*56 + m_dx) % 2700) : 12'd0;

blk_mem_gen_1_missile missile_pixel0(
  .clka(clk_25Hz),
  .wea(0),
  .addra(m_pixel_addr),
  .dina(m_data[11:0]),
  .douta(m_pixel)
);

// -------
always @*
    case({m_enable, r_enable, d_enable})
        3'b000: begin d_die = 0; r_die = 0; Pixel = 12'hfff; end
        3'b001: begin d_die = 0; r_die = 0; Pixel = (d_valid == 1'b1)? d_pixel:12'hfff; end
        3'b010: begin d_die = 0; r_die = 0; Pixel = (r_valid == 1'b1)? r_pixel:12'hfff; end
        3'b011: begin d_die = 1; r_die = 1; Pixel = 12'hfff; end // both die
        3'b100: begin d_die = 0; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        3'b101: begin d_die = 1; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        3'b110: begin d_die = 0; r_die = 0; Pixel = (r_valid == 1'b1)? r_pixel:12'hfff; end
        3'b111: begin d_die = 1; r_die = 1; Pixel = 12'hfff; end
        default: begin d_die = 0; r_die = 0; Pixel = 12'hfff; end
    endcase
        
reg [19:0]cnt;
always @(posedge clk_25Hz or negedge rst)
    if (~rst) begin
        Event <= 2'b00;
        cnt <= 0;
    end else if ({d_die, r_die} != 2'b00 && Event != {d_die, r_die}) begin
        Event <= {d_die, r_die};
        cnt <= 0;
    end else if (cnt[19] != 1)
        cnt <= cnt + 1;
    else
        Event <= 2'b00;
            

endmodule
