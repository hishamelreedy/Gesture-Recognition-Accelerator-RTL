module conv2d3x3#(parameter datwidth=16,input_channel=3,output_filter=1,inputsize=224, outputsize=222,pad=0, stride=2, start_channel=0, output_size=111, inpfile="inpf.txt",weightfile="conv1wf1.txt",outputfile="opf.txt")
                (clk,rst, currentRdChBuffer,imgdata1, imgdata2, imgdata3, imgdata4, imgdata5, imgdata6, imgdata7, imgdata8, imgdata9, output_im,bias, i_data_valid,o_convolved_data_valid);
input clk, rst, i_data_valid;
input [2*datwidth-1:0] bias;
output [datwidth-1:0] output_im;
reg [datwidth-1:0] kernel [9*input_channel-1:0];
input [datwidth-1:0] imgdata1, imgdata2, imgdata3, imgdata4, imgdata5, imgdata6, imgdata7, imgdata8, imgdata9;
input [1:0] currentRdChBuffer;
output o_convolved_data_valid;
initial
begin
    // Inserting Kernel Data into Rom
    $readmemh(weightfile,kernel);

end




// Convolution Operation
// Multiplication
// Mult Regs
reg multDataValid;
reg [2*datwidth-1:0] multData[8:0];
wire [2*datwidth-1:0] multDataw[8:0];
// Addresses
wire [2*datwidth-1:0] kaddr;
assign kaddr = currentRdChBuffer*9;
//Line 1
mul_signed mul1 (kernel[kaddr+0],imgdata1,multDataw[0]);
mul_signed mul2 (kernel[kaddr+1],imgdata2,multDataw[1]);
mul_signed mul3 (kernel[kaddr+2],imgdata3,multDataw[2]);
// Line 2
mul_signed mul4 (kernel[kaddr+3],imgdata4,multDataw[3]);
mul_signed mul5 (kernel[kaddr+4],imgdata5,multDataw[4]);
mul_signed mul6 (kernel[kaddr+5],imgdata6,multDataw[5]);
// Line 3
mul_signed mul7 (kernel[kaddr+6],imgdata7,multDataw[6]);
mul_signed mul8 (kernel[kaddr+7],imgdata8,multDataw[7]);
mul_signed mul9 (kernel[kaddr+8],imgdata9,multDataw[8]);

always @(posedge clk)
begin
    // Channel X
    // Line 1
    multData[0] <= multDataw[0];
    multData[1] <= multDataw[1];
    multData[2] <= multDataw[2];
    // Line 2
    multData[3] <= multDataw[3];
    multData[4] <= multDataw[4];
    multData[5] <= multDataw[5];
    // Line 2
    multData[6] <= multDataw[6];
    multData[7] <= multDataw[7];
    multData[8] <= multDataw[8];
    // Valid
    multDataValid <= i_data_valid;
end

// Adder Tree
reg [2*datwidth-1:0] sum1,sum2,sum3;
reg [2*datwidth-1:0] totalsum;
reg [2*datwidth-1:0] channelsum;
reg [datwidth-1:0] sumData;
reg sumDataValid;
always @(*)
begin
    // Channel Adder Tree
    sum1 = multData[0] + multData[1] + multData[2];
    sum2 = multData[3] + multData[4] + multData[5];
    sum3 = multData[6] + multData[7] + multData[8];
    totalsum = sum1 + sum2 + sum3;
end

always @(posedge clk)
begin
    if (rst)
        channelsum <= 0;
    else begin
        if (multDataValid && currentRdChBuffer==2'b01)
            channelsum <= bias+totalsum;
        else if(multDataValid)
            channelsum <= channelsum + totalsum;
    end
end

always @(posedge clk)
begin
    sumData <= {channelsum[23:16],channelsum[15:8]};
    sumDataValid <= multDataValid;
end

reg validch;
always @(posedge clk)
begin
    validch <= (currentRdChBuffer==2'b10);
end
reg validchd;
always @(posedge clk)
begin
    validchd <= validch;
end
reg validchd2;
always @(posedge clk)
begin
    validchd2 <= validchd;
end

reg [datwidth-1:0] o_convolved_data;
reg o_convolved_data_valid;
always @(posedge clk)
begin
    // Relu
    o_convolved_data <= sumData;
    //o_convolved_data <= $signed(sumData) > 0? $signed(sumData):16'd0;
    if (validchd2)
        o_convolved_data_valid <= sumDataValid;
    else
        o_convolved_data_valid <= 1'b0;
end
assign output_im = o_convolved_data_valid? o_convolved_data : 16'd0;

endmodule

module mul_signed (a,b,z); // 16x16 signed multiplier
	input [15:0] a, b; // a, b
	output [31:0] z; // z = a * b
	
	wire [15:0] ab0 = a & {16{b[0]}}; // a or 0 for b[0]
	wire [15:0] ab1 = a & {16{b[1]}}; // a or 0 for b[1]
	wire [15:0] ab2 = a & {16{b[2]}}; // a or 0 for b[2]
	wire [15:0] ab3 = a & {16{b[3]}}; // a or 0 for b[3]
	wire [15:0] ab4 = a & {16{b[4]}}; // a or 0 for b[4]
	wire [15:0] ab5 = a & {16{b[5]}}; // a or 0 for b[5]
	wire [15:0] ab6 = a & {16{b[6]}}; // a or 0 for b[6]
	wire [15:0] ab7 = a & {16{b[7]}}; // a or 0 for b[7]
	wire [15:0] ab8 = a & {16{b[8]}}; // a or 0 for b[0]
	wire [15:0] ab9 = a & {16{b[9]}}; // a or 0 for b[1]
	wire [15:0] ab10 = a & {16{b[10]}}; // a or 0 for b[2]
	wire [15:0] ab11 = a & {16{b[11]}}; // a or 0 for b[3]
	wire [15:0] ab12 = a & {16{b[12]}}; // a or 0 for b[4]
	wire [15:0] ab13 = a & {16{b[13]}}; // a or 0 for b[5]
	wire [15:0] ab14 = a & {16{b[14]}}; // a or 0 for b[6]
	wire [15:0] ab15 = a & {16{b[15]}}; // a or 0 for b[7]
	
	assign z = (({16'b1, ~ab0[15],   ab0[14:0]}               +   // << 0, + 1 in bit 16
					 {15'b0, ~ab1[15],   ab1[14:0],  1'b0})   +   // << 1
					({14'b0, ~ab2[15],   ab2[14:0],  2'b0}    +   // << 2
					 {13'b0, ~ab3[15],   ab3[14:0],  3'b0}))  +   // << 3
					(({12'b0,~ab4[15],   ab4[14:0],  4'b0}    +   // << 4
					 {11'b0, ~ab5[15],   ab5[14:0],  5'b0})   +   // << 5
					({10'b0, ~ab6[15],   ab6[14:0],  6'b0}    +   // << 6
					 {9'b0,  ~ab7[15],   ab7[14:0],  7'b0}))  +   // << 7
				  (({8'b0,  ~ab8[15],   ab8[14:0],  8'b0}     +   // << 8
					 {7'b0,  ~ab9[15],   ab9[14:0],  9'b0})   +   // << 9
					({6'b0,  ~ab10[15],  ab10[14:0],  10'b0}  +   // << 10
					 {5'b0,  ~ab11[15],  ab11[14:0],  11'b0}))+   // << 11
				  (({4'b0,  ~ab12[15],  ab12[14:0],  12'b0}   +   // << 12
					 {3'b0,  ~ab13[15],  ab13[14:0],  13'b0}) +   // << 13
					({2'b0,  ~ab14[15],  ab14[14:0],  14'b0}  +   // << 14
					 {1'b1,   ab15[15], ~ab15[14:0],  15'b0}));   // << 15, + 1 in bit 31
endmodule
