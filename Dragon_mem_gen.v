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


module mem_gen(clk_25Hz, clk_22, rst, h_cnt, v_cnt, 
d_x, d_y, d1_x, d1_y, d2_x, d2_y,
r_x, r_y, m_x, m_y, Pixel, Event, d_valid, r_valid, m_valid, d1_valid, d2_valid);
input clk_25Hz, clk_22, rst;
input [9:0]h_cnt, v_cnt;
input [9:0]d_x, d_y;
input [9:0]d1_x, d1_y;
input [9:0]d2_x, d2_y;
input [9:0]r_x, r_y;
input [9:0]m_x, m_y;
output reg [11:0]Pixel;
output reg [3:0]Event;
input d_valid, r_valid, m_valid, d1_valid, d2_valid;
// dragon_mem_gen
wire [11:0]d_data;
wire [11:0]d_pixel;
reg [11:0]d_pixel_addr;
reg [9:0]d_dx, d_dy;

// check in the range
reg d_range;
reg d_enable;
// =========================
// dragon1_mem_gen
wire [11:0]d1_data;
wire [11:0]d1_pixel;
reg [11:0]d1_pixel_addr;
reg [9:0]d1_dx, d1_dy;

// check in the range
reg d1_range;
reg d1_enable;

// =========================
// dragon1_mem_gen
wire [11:0]d2_data;
wire [11:0]d2_pixel;
reg [11:0]d2_pixel_addr;
reg [9:0]d2_dx, d2_dy;

// check in the range
reg d2_range;
reg d2_enable;

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
reg d_die, d1_die, d2_die, r_die;


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
    d1_dx = h_cnt - d1_x;
    d1_dy = v_cnt - d1_y;
    d1_range = ((d1_x <= h_cnt) & ((h_cnt - d1_x) < 40) & (v_cnt >= d1_y) & ((v_cnt - d1_y) < 30));
    d1_enable = (d1_range & d1_valid)? 1:0;
end

always @*
    d1_pixel_addr = (d1_enable)? ((d1_dy*40 + d1_dx) % 1200) : 12'd0;

blk_mem_gen_0 dragon_pixel1(
  .clka(clk_25Hz),
  .wea(0),
  .addra(d1_pixel_addr),
  .dina(d1_data[11:0]),
  .douta(d1_pixel)
); 

// ----------------------------
always @* begin
    d2_dx = h_cnt - d2_x;
    d2_dy = v_cnt - d2_y;
    d2_range = ((d2_x <= h_cnt) & ((h_cnt - d2_x) < 40) & (v_cnt >= d2_y) & ((v_cnt - d2_y) < 30));
    d2_enable = (d2_range & d2_valid)? 1:0;
end

always @*
    d2_pixel_addr = (d2_enable)? ((d2_dy*40 + d2_dx) % 1200) : 12'd0;

blk_mem_gen_0 dragon_pixel2(
  .clka(clk_25Hz),
  .wea(0),
  .addra(d2_pixel_addr),
  .dina(d2_data[11:0]),
  .douta(d2_pixel)
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
    case({m_enable, r_enable, d_enable, d1_enable, d2_enable})
        5'b00000: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = 12'hfff; end
        5'b00001: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d2_valid == 1'b1)? d2_pixel:12'hfff; end
        5'b00010: begin
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d1_valid == 1'b1)? d1_pixel:12'hfff; end
        5'b00011: begin
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d1_valid == 1'b1)? d1_pixel:12'hfff; end
        5'b00100: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d_valid == 1'b1)? d_pixel:12'hfff; end
        5'b00101: begin
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d_valid == 1'b1)? d_pixel:12'hfff; end
        5'b00110: begin
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d_valid == 1'b1)? d_pixel:12'hfff; end
        5'b00111: begin
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (d_valid == 1'b1)? d_pixel:12'hfff; end
        5'b01000: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (r_valid == 1'b1)? r_pixel:12'hfff; end
        5'b01001: begin
            d_die = 0; d1_die = 0; d2_die = 1; r_die = 1; Pixel = 12'hfff; end
        5'b01010: begin
            d_die = 0; d1_die = 1; d2_die = 0; r_die = 1; Pixel = 12'hfff; end
        5'b01011: begin
            d_die = 0; d1_die = 1; d2_die = 1; r_die = 1; Pixel = 12'hfff; end
        5'b01100: begin 
            d_die = 1; d1_die = 0; d2_die = 0; r_die = 1; Pixel = 12'hfff; end // both die
        5'b01101: begin
            d_die = 1; d1_die = 0; d2_die = 1; r_die = 1; Pixel = 12'hfff; end
        5'b01110: begin
            d_die = 1; d1_die = 1; d2_die = 0; r_die = 1; Pixel = 12'hfff; end
        5'b01111: begin
            d_die = 1; d1_die = 1; d2_die = 1; r_die = 1; Pixel = 12'hfff; end
        5'b10000: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10001: begin
            d_die = 0; d1_die = 0; d2_die = 1; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10010: begin
            d_die = 0; d1_die = 1; d2_die = 0; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10011: begin
            d_die = 0; d1_die = 1; d2_die = 1; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10100: begin 
            d_die = 1; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10101: begin
            d_die = 1; d1_die = 0; d2_die = 1; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10110: begin
            d_die = 1; d1_die = 1; d2_die = 0; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b10111: begin
            d_die = 1; d1_die = 1; d2_die = 1; r_die = 0; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11000: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = (r_valid == 1'b1)? r_pixel:12'hfff; end
        5'b11001: begin
            d_die = 0; d1_die = 0; d2_die = 1; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11010: begin
            d_die = 0; d1_die = 1; d2_die = 0; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11011: begin
            d_die = 0; d1_die = 1; d2_die = 1; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11100: begin 
            d_die = 1; d1_die = 0; d2_die = 0; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11101: begin
            d_die = 1; d1_die = 0; d2_die = 1; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11110: begin
            d_die = 1; d1_die = 1; d2_die = 0; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        5'b11111: begin
            d_die = 1; d1_die = 1; d2_die = 1; r_die = 1; Pixel = (m_valid == 1'b1)? m_pixel:12'hfff; end
        default:  begin d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = 12'hfff; end
    endcase
        
reg [19:0]cnt;
always @(posedge clk_25Hz or negedge rst)
    if (~rst) begin
        Event <= 4'd0;
        cnt <= 0;
    end else if ({d_die, d1_die, d2_die, r_die} != 4'd0 && Event != {d_die, d1_die, d2_die, r_die}) begin
        Event <= {d_die, d1_die, d2_die, r_die};
        cnt <= 0;
    end else if (cnt[19] != 1)
        cnt <= cnt + 1;
    else
        Event <= 4'd0;
            

endmodule
