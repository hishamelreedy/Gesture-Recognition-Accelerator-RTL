`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 10:09:05 PM
// Design Name: 
// Module Name: conv
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


module conv(
input        i_clk,
//input [71:0] i_pixel_data,
input [71:0] i_pixel_data1,
input [71:0] i_pixel_data2,
input [71:0] i_pixel_data3,
input        i_pixel_data_valid,
output reg [21:0] o_convolved_data,
output reg   o_convolved_data_valid
    );
    
integer i; 
reg [15:0] kernel1_1 [8:0];
reg [15:0] kernel1_2 [8:0];
reg [15:0] kernel1_3 [8:0];
reg [15:0] multData1_1[8:0];
reg [15:0] multData1_2[8:0];
reg [15:0] multData1_3[8:0];
reg [15:0] sumData;
reg multDataValid;
reg sumDataValid;
reg convolved_data_int_valid;
reg [15:0] sum1_1,sum1_2,sum1_3, sum2_1,sum2_2,sum2_3, sum3_1,sum3_2,sum3_3;
reg [15:0] totalsum1,totalsum2,totalsum3;
reg [15:0] totalsum1d,totalsum2d,totalsum3d;
reg [15:0] channelsum;
reg [71:0] i_pixel_data1d [8:0];
reg [71:0] i_pixel_data2d [8:0];
reg [71:0] i_pixel_data3d [8:0];
initial
begin
    kernel1_1[0] =  1;
    kernel1_1[1] =  2;
    kernel1_1[2] =  1;
    kernel1_1[3] =  0;
    kernel1_1[4] =  0;
    kernel1_1[5] =  0;
    kernel1_1[6] = -1;
    kernel1_1[7] = -2;
    kernel1_1[8] = -1;
    
    kernel1_2[0] =  1;
    kernel1_2[1] =  2;
    kernel1_2[2] =  1;
    kernel1_2[3] =  0;
    kernel1_2[4] =  0;
    kernel1_2[5] =  0;
    kernel1_2[6] = -1;
    kernel1_2[7] = -2;
    kernel1_2[8] = -1;
    
    kernel1_3[0] =  1;
    kernel1_3[1] =  2;
    kernel1_3[2] =  1;
    kernel1_3[3] =  0;
    kernel1_3[4] =  0;
    kernel1_3[5] =  0;
    kernel1_3[6] = -1;
    kernel1_3[7] = -2;
    kernel1_3[8] = -1;

end    
    
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        i_pixel_data1d[i] <= i_pixel_data1[i*8+:8];
        i_pixel_data2d[i] <= i_pixel_data2[i*8+:8];
        i_pixel_data3d[i] <= i_pixel_data3[i*8+:8];
        multData1_1[i] <= $signed(kernel1_1[i])*$signed({8'h00,i_pixel_data1[i*8+:8]});
        multData1_2[i] <= $signed(kernel1_2[i])*$signed({8'h00,i_pixel_data2[i*8+:8]});
        multData1_3[i] <= $signed(kernel1_3[i])*$signed({8'h00,i_pixel_data3[i*8+:8]});
    end
    multDataValid <= i_pixel_data_valid;
end
// Adder Tree
always @(*)
begin
    // Channel 1 Adder Tree
    sum1_1 = $signed(multData1_1[0]) + $signed(multData1_1[1]) + $signed(multData1_1[2]);
    sum1_2 = $signed(multData1_1[3]) + $signed(multData1_1[4]) + $signed(multData1_1[5]);
    sum1_3 = $signed(multData1_1[6]) + $signed(multData1_1[7]) + $signed(multData1_1[8]);
    totalsum1 = $signed(sum1_1) + $signed(sum1_2) + $signed(sum1_3);
    // Channel 2 Adder Tree
    sum2_1 = $signed(multData1_2[0]) + $signed(multData1_2[1]) + $signed(multData1_2[2]);
    sum2_2 = $signed(multData1_2[3]) + $signed(multData1_2[4]) + $signed(multData1_2[5]);
    sum2_3 = $signed(multData1_2[6]) + $signed(multData1_2[7]) + $signed(multData1_2[8]);
    totalsum2 = $signed(sum2_1) + $signed(sum2_2) + $signed(sum2_3);
    // Channel 3 Adder Tree
    sum3_1 = $signed(multData1_3[0]) + $signed(multData1_3[1]) + $signed(multData1_3[2]);
    sum3_2 = $signed(multData1_3[3]) + $signed(multData1_3[4]) + $signed(multData1_3[5]);
    sum3_3 = $signed(multData1_3[6]) + $signed(multData1_3[7]) + $signed(multData1_3[8]);
    totalsum3 = $signed(sum3_1) + $signed(sum3_2) + $signed(sum3_3);

    // Adding all channels
    channelsum = $signed(totalsum1) + $signed(totalsum2) + $signed(totalsum3);
end
// End Adder Tree
// always @(*)
// begin
//     sumDataInt1 = 0;
//     sumDataInt2 = 0;
//     for(i=0;i<9;i=i+1)
//     begin
//         sumDataInt1 = $signed(sumDataInt1) + $signed(multData1_1[i]) + $signed(multData1_2[i]) + $signed(multData1_3[i]);
//         sumDataInt2 = $signed(sumDataInt2) + $signed(multData2_1[i]) + $signed(multData2_2[i]) + $signed(multData2_3[i]);
//     end
// end

always @(posedge i_clk)
begin
    sumData <= $signed(channelsum);
    totalsum1d <= $signed(totalsum1);
    totalsum2d <= $signed(totalsum2);
    totalsum3d <= $signed(totalsum3);
    sumDataValid <= multDataValid;
end
    
always @(posedge i_clk)
begin
    o_convolved_data <= $signed(sumData);
    o_convolved_data_valid <= sumDataValid;
end
    
endmodule