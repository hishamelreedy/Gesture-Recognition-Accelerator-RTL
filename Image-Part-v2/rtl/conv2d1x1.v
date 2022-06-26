// Conv 2D size 1x1
// Parallelism 16 channel
module conv2d1x1#(parameter datwidth=16, inputchannel=64, inputsize=55)
                (clk, rst, i_data_valid, firstvalue,
                 imgdata, kernel, bias, o_convolved_data, o_convolved_data_valid);
input clk, rst, i_data_valid;
input firstvalue;
input [16*16-1:0] imgdata, kernel;
reg [15:0] imgdatamem [0:15];
reg [15:0] kernelmem [0:15];
input [15:0] bias;
output reg [15:0] o_convolved_data;
output reg o_convolved_data_valid;

integer i;
always @(*)
begin
for (i=0; i<16; i=i+1) begin
    imgdatamem[i]<=imgdata[i*16+:16];
    kernelmem[i] <= kernel[i*16+:16];
end
end

// Convolution Operation

// Multiplication
reg multDataValid;
reg [31:0] multData [0:15];
wire [31:0] multDataw [0:15];
mul_signed mul1 (kernelmem[0],imgdatamem[0],multDataw[0]);
mul_signed mul2 (kernelmem[1],imgdatamem[1],multDataw[1]);
mul_signed mul3 (kernelmem[2],imgdatamem[2],multDataw[2]);
mul_signed mul4 (kernelmem[3],imgdatamem[3],multDataw[3]);
mul_signed mul5 (kernelmem[4],imgdatamem[4],multDataw[4]);
mul_signed mul6 (kernelmem[5],imgdatamem[5],multDataw[5]);
mul_signed mul7 (kernelmem[6],imgdatamem[6],multDataw[6]);
mul_signed mul8 (kernelmem[7],imgdatamem[7],multDataw[7]);
mul_signed mul9 (kernelmem[8],imgdatamem[8],multDataw[8]);
mul_signed mul10 (kernelmem[9],imgdatamem[9],multDataw[9]);
mul_signed mul11 (kernelmem[10],imgdatamem[10],multDataw[10]);
mul_signed mul12 (kernelmem[11],imgdatamem[11],multDataw[11]);
mul_signed mul13 (kernelmem[12],imgdatamem[12],multDataw[12]);
mul_signed mul14 (kernelmem[13],imgdatamem[13],multDataw[13]);
mul_signed mul15 (kernelmem[14],imgdatamem[14],multDataw[14]);
mul_signed mul16 (kernelmem[15],imgdatamem[15],multDataw[15]);

always @(*)
begin
    // Channel 1
    multData[0] <= multDataw[0];
    multData[1] <= multDataw[1];
    multData[2] <= multDataw[2];
    multData[3] <= multDataw[3];
    multData[4] <= multDataw[4];
    multData[5] <= multDataw[5];
    multData[6] <= multDataw[6];
    multData[7] <= multDataw[7];
    multData[8] <= multDataw[8];
    multData[9] <= multDataw[9];
    multData[10] <= multDataw[10];
    multData[11] <= multDataw[11];
    multData[12] <= multDataw[12];
    multData[13] <= multDataw[13];
    multData[14] <= multDataw[14];
    multData[15] <= multDataw[15];

    multDataValid <= i_data_valid;
end
// Adder Tree
reg [2*datwidth-1:0] sum1,sum2,sum3,sum4,sum5,sum6 ='d0;
reg [2*datwidth-1:0] sum123, sum456='d0;
reg [2*datwidth-1:0] totalsum='d0;
reg [2*datwidth-1:0] totalsum2;

always @(*)
begin
    // Channel Adder Tree
    sum1 = multData[0] + multData[1] + multData[2];
    sum2 = multData[3] + multData[4] + multData[5];
    sum3 = multData[6] + multData[7] + multData[8];
    sum123 = sum1 + sum2 + sum3;
    sum4 = multData[9] + multData[10] + multData[11];
    sum5 = multData[12] + multData[13];
    sum6 = multData[14] + multData[15];
    sum456 = sum4 + sum5 + sum6;
end
always @(*)
begin
    totalsum = sum123 + sum456;
    totalsum2 = totalsum + {8'd0,bias,8'd0};
end
reg sumValid;
always @(*)
begin
    sumValid <= multDataValid;
end
// Accumulator
reg [31:0] channelsum;
always @(posedge clk)
begin
    if (rst)
        channelsum <= 0;
    else begin
        if(sumValid && firstvalue)
            //channelsum <= {totalsum[23:16],totalsum[15:8]} + bias;
            channelsum <= totalsum2;
        else if (sumValid)
            channelsum <= channelsum + totalsum;

    end
end

reg [15:0] sumData;
reg sumDataValid;
always @(*)
begin
    sumData <= {channelsum[23:16],channelsum[15:8]};
    sumDataValid <= multDataValid;
end

always @(*)
begin
    o_convolved_data <= sumData;
    //o_convolved_data <= sumData > 0? sumData:16'd0;
    o_convolved_data_valid <= sumDataValid;
end


endmodule