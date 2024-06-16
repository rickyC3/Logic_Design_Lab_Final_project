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


module mem_gen(clk_25Hz, clk_22,  sw_in_t1, rst, h_cnt, v_cnt, 
d_x, d_y, d1_x, d1_y, d2_x, d2_y,
r_x, r_y, m_x, m_y, pixel, Event, d_valid, r_valid, m_valid, d1_valid, d2_valid, otk_sign);
input clk_25Hz, clk_22, rst; // 25MHz, 100/2^22 Hz, 
input sw_in_t1;
input [9:0]h_cnt, v_cnt; // the position vga print right now
input [9:0]d_x, d_y;   // dragon0's position
input [9:0]d1_x, d1_y; // dragon1's position
input [9:0]d2_x, d2_y; // dragon2's position
input [9:0]r_x, r_y;   // robot's position
input [9:0]m_x, m_y;   // missile's position
output reg [11:0]pixel; // eventually output
output reg [3:0]Event;  // gobal podcast: character die sign
output otk_sign;
input d_valid, r_valid, m_valid, d1_valid, d2_valid; // character life state (missile active or cd state)

reg [11:0]Pixel;

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

// background
wire [11:0]b0_data;
wire [11:0]b0_pixel;
wire [11:0]b1_data;
wire [11:0]b1_pixel;
reg [14:0]b_pixel_addr;
reg [11:0]b_pixel;

// otk cnt
integer otk_cnt;
integer cd_cnt;
reg otk_sign;

// new* -------------------- for otk, you has 3 missile
reg [9:0]m_otk_dx, m_otk_dy;
reg [9:0]m_otk_dx1, m_otk_dy1;
reg m_otk_range1, m_otk_enable1;
reg m_otk_range, m_otk_enable;


// -------------------------------
reg d_die, d1_die, d2_die, r_die; // the char. die signal 
// char life state would be judged in this part, and output by Event

// -------------------------------

always @* begin
    // the distance between show point and dragon's location
    d_dx = h_cnt - d_x;
    d_dy = v_cnt - d_y; 
    // check the coordinate point is in the dragon's image range
    d_range = ((d_x <= h_cnt) & ((h_cnt - d_x) < 40) & (v_cnt >= d_y) & ((v_cnt - d_y) < 30));
    d_enable = (d_range & d_valid)? 1:0; // control choose dragon's pixel or not
end

always @*
    // 2D to 1D, generate dragon's pixel addr.
    // size of dragon image 40*30(width*height)
    d_pixel_addr = (d_enable)? ((d_dy*40 + d_dx) % 1200) : 12'd0;

blk_mem_gen_0 dragon_pixel0(
  .clka(clk_25Hz),
  .wea(0),
  .addra(d_pixel_addr),
  .dina(d_data[11:0]),
  .douta(d_pixel)
); 

// ----------------------------
// dragon1, dragon2 same as dragon
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
    // the distance between the h, v point and robot location
    r_dx = h_cnt - r_x;
    r_dy = v_cnt - r_y;
    // check the h,v cnt coordinate point is in robot's image range?
    r_range = ((r_x <= h_cnt) & ((h_cnt - r_x) < 40) & (v_cnt >= r_y) & ((v_cnt - r_y) < 30));
    // judge going to show robot's pixel or not
    r_enable = (r_range & r_valid)? 1:0;
end

always @*
    // 2D to 1D, generate robot's addr (size: 40*30)
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
    // distance between point and missile
    m_dx = h_cnt - m_x;
    m_dy = v_cnt - m_y;
    // check h,v cnt is in missile's image range?
    m_range = ((m_x <= h_cnt) & ((h_cnt - m_x) < 56) & (v_cnt >= m_y) & ((v_cnt - m_y) < 12));
    // judge going to show missile's pixel or not
    m_enable = ((m_range & m_valid) || (m_otk_enable) || (m_otk_enable1))? 1:0;
end

// -------------------------

always @* 
    // 2D to 1D, generate missile's addr (size: 56*12)
    if (m_enable)
        m_pixel_addr = ((m_dy*56 + m_dx) % 672);
    else if (m_otk_enable)
        m_pixel_addr = ((m_otk_dy*56 + m_dx) % 672);
    else if (m_otk_enable1)
        m_pixel_addr = ((m_otk_dy1*56 + m_dx) % 672);
    else
        m_pixel_addr = 12'd0;




always @* begin
    // distance between point and missile
    m_otk_dx = h_cnt - m_x;
    m_otk_dy = v_cnt - (m_y + 20);
    // check h,v cnt is in missile's image range?
    m_otk_range = ((m_x <= h_cnt) & ((h_cnt - m_x) < 56) & (v_cnt >= (m_y + 20)) & ((v_cnt - (m_y + 20)) < 12));
    // judge going to show missile's pixel or not
    m_otk_enable = (m_otk_range & m_valid & otk_sign)? 1:0;
end

always @* begin
    // distance between point and missile
    m_otk_dx1 = h_cnt - m_x;
    m_otk_dy1 = v_cnt - (m_y - 20);
    // check h,v cnt is in missile's image range?
    m_otk_range1 = ((m_x <= h_cnt) & ((h_cnt - m_x) < 56) & (v_cnt >= (m_y - 20)) & ((v_cnt - (m_y - 20)) < 12));
    // judge going to show missile's pixel or not
    m_otk_enable1 = (m_otk_range1 & m_valid & m_y >= 20 & otk_sign)? 1:0;
end

blk_mem_gen_1_missile missile_pixel0(
  .clka(clk_25Hz),
  .wea(0),
  .addra(m_pixel_addr),
  .dina(m_data[11:0]),
  .douta(m_pixel)
);

// background
always @* begin
    b_pixel_addr = ((v_cnt >> 2)*160 + (h_cnt >> 2))%19200;
    b_pixel = (sw_in_t1)? b0_pixel:b1_pixel; 
end

blk_mem_gen_1_back0 back0_pixel0(
      .clka(clk_25Hz),
      .wea(0),
      .addra(b_pixel_addr),
      .dina(b0_data[11:0]),
      .douta(b0_pixel)
    );

    
blk_mem_gen_1 back1_pixel0(
      .clka(clk_25Hz),
      .wea(0),
      .addra(b_pixel_addr),
      .dina(b1_data[11:0]),
      .douta(b1_pixel)
    );

// fsm -------
// if a point belong to several char, descide which pixel should print
// if not char --> 12'hfff(white)
// at the same time, we deal the collision problem here
// if collision --> judge character's die state
always @*
    case({m_enable, r_enable, d_enable, d1_enable, d2_enable})
        5'b00000: begin 
            d_die = 0; d1_die = 0; d2_die = 0; r_die = 0; Pixel = 12'hfff; end
        5'b00001: begin 
            // if dragons collision --> print dragon first
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
            d_die = 0; d1_die = 0; d2_die = 1; r_die = 1; Pixel = 12'hfff; end// both die
        5'b01010: begin
            d_die = 0; d1_die = 1; d2_die = 0; r_die = 1; Pixel = 12'hfff; end
        5'b01011: begin
            d_die = 0; d1_die = 1; d2_die = 1; r_die = 1; Pixel = 12'hfff; end
        5'b01100: begin 
            d_die = 1; d1_die = 0; d2_die = 0; r_die = 1; Pixel = 12'hfff; end 
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

always @*
    pixel = (Pixel == 12'hfff)? b_pixel:Pixel;
    
reg [19:0]cnt;
// covert the 25MHz to 100M/2^22 signal
always @(posedge clk_25Hz or negedge rst)
    if (~rst) begin
        Event <= 4'd0;
        cnt <= 0;
    // if has new event, output new event first 
    end else if ({d_die, d1_die, d2_die, r_die} != 4'd0 && Event != {d_die, d1_die, d2_die, r_die}) begin
        Event <= {d_die, d1_die, d2_die, r_die};
        cnt <= 0;
    // podcast valid time
    end else if (cnt[19] != 1) // add some time, longer valid time
        cnt <= cnt + 1;
    else
    // podcast end
        Event <= 4'd0;

// otk triggle
always @(posedge clk_22 or negedge rst)
    if (~rst) begin
        otk_cnt <= 0;
        otk_sign <= 0;
        cd_cnt <= 0;
    end else if (Event[0]) begin
         otk_cnt <= 0;
         otk_sign <= 0;
         cd_cnt <= 0;
    end else if (otk_sign && cd_cnt == 200) begin // cd time
        otk_sign <= 0;
        cd_cnt <= 0;
        otk_cnt <= 0;
    end else if (otk_sign) begin
        cd_cnt <= cd_cnt + 1;
        otk_cnt <= 0;
    end else if (~otk_sign && otk_cnt == 10) begin
        cd_cnt <= 0;
        otk_cnt <= 0;
        otk_sign <= 1;
    end else if (~otk_sign) begin
        case(Event[3:1]) // add the points by each condition
            3'b001, 3'b010, 3'b100: begin otk_cnt <= otk_cnt + 1;end
            3'b011, 3'b110, 3'b101: begin otk_cnt <= otk_cnt + 2;end
            3'b111: begin otk_cnt <= otk_cnt + 3;end
            default: otk_cnt <= otk_cnt;
        endcase
    end else begin
        cd_cnt <= cd_cnt;
        otk_sign <= otk_sign;
        otk_cnt <= otk_cnt;
    end
        
    

        
   
        

endmodule
