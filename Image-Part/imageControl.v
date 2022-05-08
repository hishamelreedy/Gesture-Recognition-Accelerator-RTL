`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2020 10:53:27 AM
// Design Name: 
// Module Name: imageControl
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

module imageControl(
input                    i_clk,
input                    i_rst,
input [7:0]              i_pixel_data1,
input [7:0]              i_pixel_data2,
input [7:0]              i_pixel_data3,
input                    i_pixel_data_valid,
output reg [71:0]        o_pixel_data1,
output reg [71:0]        o_pixel_data2,
output reg [71:0]        o_pixel_data3,
output                   o_pixel_data_valid,
output reg               o_intr
);

reg [7:0] pixelCounter;
reg [1:0] currentWrLineBuffer;
reg [3:0] lineBuffDataValid;
reg [3:0] lineBuffRdData;
reg [1:0] currentRdLineBuffer;
wire [23:0] lb0data_1;
wire [23:0] lb1data_1;
wire [23:0] lb2data_1;
wire [23:0] lb3data_1;
wire [23:0] lb0data_2;
wire [23:0] lb1data_2;
wire [23:0] lb2data_2;
wire [23:0] lb3data_2;
wire [23:0] lb0data_3;
wire [23:0] lb1data_3;
wire [23:0] lb2data_3;
wire [23:0] lb3data_3;
reg [7:0] rdCounter;
reg rd_line_buffer;
reg [11:0] totalPixelCounter;
reg rdState;

localparam IDLE = 'b0,
           RD_BUFFER = 'b1;

assign o_pixel_data_valid = rd_line_buffer;

always @(posedge i_clk)
begin
    if(i_rst)
        totalPixelCounter <= 0;
    else
    begin
        if(i_pixel_data_valid & !rd_line_buffer)
            totalPixelCounter <= totalPixelCounter + 1;
        else if(!i_pixel_data_valid & rd_line_buffer & rdCounter==220)
            totalPixelCounter <= totalPixelCounter - 2;
        else if(!i_pixel_data_valid & rd_line_buffer)
            totalPixelCounter <= totalPixelCounter - 2;
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
    begin
        rdState <= IDLE;
        rd_line_buffer <= 1'b0;
        o_intr <= 1'b0;
    end
    else
    begin
        case(rdState)
            IDLE:begin
                o_intr <= 1'b0;
                if(totalPixelCounter >= 224*4)
                begin
                    rd_line_buffer <= 1'b1;
                    rdState <= RD_BUFFER;
                end
            end
            RD_BUFFER:begin
                if(rdCounter == 220)
                begin
                    rdState <= IDLE;
                    rd_line_buffer <= 1'b0;
                    o_intr <= 1'b1;
                end
            end
        endcase
    end
end
    
always @(posedge i_clk)
begin
    if(i_rst)
        pixelCounter <= 0;
    else 
    begin 
        if(i_pixel_data_valid)
            if (pixelCounter == 8'd223)
                pixelCounter <= 0;
            else
                pixelCounter <= pixelCounter + 1;
    end
end


always @(posedge i_clk)
begin
    if(i_rst)
        currentWrLineBuffer <= 0;
    else
    begin
        if(pixelCounter == 8'd223 & i_pixel_data_valid)
            currentWrLineBuffer <= currentWrLineBuffer+1;
    end
end


always @(*)
begin
    lineBuffDataValid = 4'h0;
    lineBuffDataValid[currentWrLineBuffer] = i_pixel_data_valid;
end

always @(posedge i_clk)
begin
    if(i_rst)
        rdCounter <= 0;
    else 
    begin
        if(rd_line_buffer)
            if(rdCounter == 8'd220)
                rdCounter <= 0;
            else
                rdCounter <= rdCounter + 2;
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
    begin
        currentRdLineBuffer <= 0;
    end
    else
    begin
        if(rdCounter == 8'd220 & rd_line_buffer)
            currentRdLineBuffer <= currentRdLineBuffer + 1;
    end
end


always @(*)
begin
    case(currentRdLineBuffer)
        0:begin
            o_pixel_data1 = {lb2data_1,lb1data_1,lb0data_1};
            o_pixel_data2 = {lb2data_2,lb1data_2,lb0data_2};
            o_pixel_data3 = {lb2data_3,lb1data_3,lb0data_3};

        end
        1:begin
            o_pixel_data1 = {lb3data_1,lb2data_1,lb1data_1};
            o_pixel_data2 = {lb3data_2,lb2data_2,lb1data_2};
            o_pixel_data3 = {lb3data_3,lb2data_3,lb1data_3};
        end
        2:begin
            o_pixel_data1 = {lb0data_1,lb3data_1,lb2data_1};
            o_pixel_data2 = {lb0data_2,lb3data_2,lb2data_2};
            o_pixel_data3 = {lb0data_3,lb3data_3,lb2data_3};
        end
        3:begin
            o_pixel_data1 = {lb1data_1,lb0data_1,lb3data_1};
            o_pixel_data2 = {lb1data_2,lb0data_2,lb3data_2};
            o_pixel_data3 = {lb1data_3,lb0data_3,lb3data_3};
        end
    endcase
end

always @(*)
begin
    case(currentRdLineBuffer)
        0:begin
            lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = 1'b0;
        end
       1:begin
            lineBuffRdData[0] = 1'b0;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
        end
       2:begin
             lineBuffRdData[0] = rd_line_buffer;
             lineBuffRdData[1] = 1'b0;
             lineBuffRdData[2] = rd_line_buffer;
             lineBuffRdData[3] = rd_line_buffer;
       end
      3:begin
             lineBuffRdData[0] = rd_line_buffer;
             lineBuffRdData[1] = rd_line_buffer;
             lineBuffRdData[2] = 1'b0;
             lineBuffRdData[3] = rd_line_buffer;
       end        
    endcase
end
    
lineBuffer lB0_1(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(i_pixel_data1),
    .i_data_valid(lineBuffDataValid[0]),
    .o_data(lb0data_1),
    .i_rd_data(lineBuffRdData[0])
 ); 
 
 lineBuffer lB1_1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     .i_data(i_pixel_data1),
     .i_data_valid(lineBuffDataValid[1]),
     .o_data(lb1data_1),
     .i_rd_data(lineBuffRdData[1])
  ); 
  
  lineBuffer lB2_1(
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_data(i_pixel_data1),
      .i_data_valid(lineBuffDataValid[2]),
      .o_data(lb2data_1),
      .i_rd_data(lineBuffRdData[2])
   ); 
   
   lineBuffer lB3_1(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data1),
       .i_data_valid(lineBuffDataValid[3]),
       .o_data(lb3data_1),
       .i_rd_data(lineBuffRdData[3])
    );    

    lineBuffer lB0_2(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data2),
        .i_data_valid(lineBuffDataValid[0]),
        .o_data(lb0data_2),
        .i_rd_data(lineBuffRdData[0])
    ); 
 
    lineBuffer lB1_2(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data2),
        .i_data_valid(lineBuffDataValid[1]),
        .o_data(lb1data_2),
        .i_rd_data(lineBuffRdData[1])
    ); 
  
    lineBuffer lB2_2(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data2),
        .i_data_valid(lineBuffDataValid[2]),
        .o_data(lb2data_2),
        .i_rd_data(lineBuffRdData[2])
    ); 
   
    lineBuffer lB3_2(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data2),
        .i_data_valid(lineBuffDataValid[3]),
        .o_data(lb3data_2),
        .i_rd_data(lineBuffRdData[3])
        );  

    lineBuffer lB0_3(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data3),
        .i_data_valid(lineBuffDataValid[0]),
        .o_data(lb0data_3),
        .i_rd_data(lineBuffRdData[0])
    ); 
 
    lineBuffer lB1_3(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data3),
        .i_data_valid(lineBuffDataValid[1]),
        .o_data(lb1data_3),
        .i_rd_data(lineBuffRdData[1])
    ); 
  
    lineBuffer lB2_3(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data3),
        .i_data_valid(lineBuffDataValid[2]),
        .o_data(lb2data_3),
        .i_rd_data(lineBuffRdData[2])
    ); 
   
    lineBuffer lB3_3(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel_data3),
        .i_data_valid(lineBuffDataValid[3]),
        .o_data(lb3data_3),
        .i_rd_data(lineBuffRdData[3])
        );      
endmodule