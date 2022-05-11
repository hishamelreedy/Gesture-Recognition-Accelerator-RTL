module conv1(clk,rst,i_data_valid, output_imw, o_convolved_data_valid);
parameter outputsize=222;
parameter stride=2;
parameter datwidth=16;
parameter inputsize = 224;
parameter input_channel = 3;
input i_data_valid;
input clk, rst;
reg [31:0] biases [0:63];
wire [datwidth-1:0] output_im [0:64-1];
output reg [datwidth*64-1:0] output_imw;
reg [datwidth-1:0] imgdata [inputsize*inputsize*input_channel-1:0];
output o_convolved_data_valid;
wire [64-1:0] convolved_data_valid;
integer i;
always @(*)
    for (i=0; i<64; i=i+1)
        output_imw[i*16+:16]=output_im[i];

initial begin
$readmemh("inpf.txt",imgdata);
$readmemh("sqnetparams/conv1/biases.txt",biases);
end

// Control Block
reg [1:0] currentRdChBuffer;
// loop on channels
always @(posedge clk)
begin
    if(rst)
    begin
        currentRdChBuffer <= 2'b00;
    end
    else
    begin
        if(currentRdChBuffer == 2'b10)
            currentRdChBuffer <= 2'b00;
        else
            currentRdChBuffer <= currentRdChBuffer + 2'b01;
    end
end

reg [7:0] rdCounter;
// loop on cells
always @(posedge clk)
begin
    if(rst)
        rdCounter <= 0;
    else 
    begin
        if (currentRdChBuffer == 2'b10)
            if(rdCounter == (outputsize-1)-(stride-1))
                rdCounter <= 0;
            else
                rdCounter <= rdCounter + stride;
    end
end

reg [7:0] currentRdLineBuffer;
// loop on lines
always @(posedge clk)
begin
    if(rst)
    begin
        currentRdLineBuffer <= 0;
    end
    else
    begin
        if(rdCounter == (outputsize-1)-(stride-1) && currentRdChBuffer==2'b10)
            if (currentRdLineBuffer==8'd223)
                currentRdLineBuffer <= 8'd0;
            else
                currentRdLineBuffer <= currentRdLineBuffer + stride;
    end
end
// Addresses
wire [2*datwidth-1:0] chaddr, lineaddr;
assign chaddr=currentRdChBuffer*224*224;
assign lineaddr = currentRdLineBuffer * 224;
// Img Data
wire [datwidth-1:0] imgdata1, imgdata2, imgdata3, imgdata4, imgdata5, imgdata6, imgdata7, imgdata8, imgdata9;
assign imgdata1=imgdata[chaddr+lineaddr+rdCounter];
assign imgdata2=imgdata[chaddr+lineaddr+rdCounter+1];
assign imgdata3=imgdata[chaddr+lineaddr+rdCounter+2];
assign imgdata4=imgdata[chaddr+lineaddr+224+rdCounter];
assign imgdata5=imgdata[chaddr+lineaddr+224+rdCounter+1];
assign imgdata6=imgdata[chaddr+lineaddr+224+rdCounter+2];
assign imgdata7=imgdata[chaddr+lineaddr+448+rdCounter];
assign imgdata8=imgdata[chaddr+lineaddr+448+rdCounter+1];
assign imgdata9=imgdata[chaddr+lineaddr+448+rdCounter+2];

assign o_convolved_data_valid = &convolved_data_valid;
// PEs
conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf1.txt")) PE1 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[0]),
        .bias(biases[0]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[0])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf2.txt")) PE2 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[1]),
        .bias(biases[1]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[1])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf3.txt")) PE3 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[2]),
        .bias(biases[2]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[2])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf4.txt")) PE4 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[3]),
        .bias(biases[3]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[3])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf5.txt")) PE5 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[4]),
        .bias(biases[4]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[4])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf6.txt")) PE6 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[5]),
        .bias(biases[5]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[5])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf7.txt")) PE7 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[6]),
        .bias(biases[6]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[6])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf8.txt")) PE8 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[7]),
        .bias(biases[7]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[7])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf9.txt")) PE9 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[8]),
        .bias(biases[8]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[8])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf10.txt")) PE10 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[9]),
        .bias(biases[9]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[9])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf11.txt")) PE11 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[10]),
        .bias(biases[10]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[10])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf12.txt")) PE12 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[11]),
        .bias(biases[11]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[11])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf13.txt")) PE13 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[12]),
        .bias(biases[12]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[12])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf14.txt")) PE14 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[13]),
        .bias(biases[13]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[13])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf15.txt")) PE15 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[14]),
        .bias(biases[14]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[14])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf16.txt")) PE16 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[15]),
        .bias(biases[15]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[15])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf17.txt")) PE17 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[16]),
        .bias(biases[16]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[16])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf18.txt")) PE18 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[17]),
        .bias(biases[17]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[17])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf19.txt")) PE19 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[18]),
        .bias(biases[18]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[18])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf20.txt")) PE20 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[19]),
        .bias(biases[19]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[19])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf21.txt")) PE21 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[20]),
        .bias(biases[20]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[20])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf22.txt")) PE22 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[21]),
        .bias(biases[21]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[21])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf23.txt")) PE23 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[22]),
        .bias(biases[22]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[22])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf24.txt")) PE24 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[23]),
        .bias(biases[23]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[23])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf25.txt")) PE25 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[24]),
        .bias(biases[24]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[24])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf26.txt")) PE26 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[25]),
        .bias(biases[25]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[25])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf27.txt")) PE27 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[26]),
        .bias(biases[26]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[26])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf28.txt")) PE28 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[27]),
        .bias(biases[27]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[27])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf29.txt")) PE29 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[28]),
        .bias(biases[28]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[28])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf30.txt")) PE30 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[29]),
        .bias(biases[29]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[29])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf31.txt")) PE31 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[30]),
        .bias(biases[30]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[30])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf32.txt")) PE32 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[31]),
        .bias(biases[31]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[31])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf33.txt")) PE33 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[32]),
        .bias(biases[32]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[32])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf34.txt")) PE34 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[33]),
        .bias(biases[33]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[33])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf35.txt")) PE35 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[34]),
        .bias(biases[34]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[34])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf36.txt")) PE36 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[35]),
        .bias(biases[35]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[35])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf37.txt")) PE37 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[36]),
        .bias(biases[36]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[36])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf38.txt")) PE38 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[37]),
        .bias(biases[37]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[37])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf39.txt")) PE39 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[38]),
        .bias(biases[38]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[38])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf40.txt")) PE40 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[39]),
        .bias(biases[39]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[39])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf41.txt")) PE41 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[40]),
        .bias(biases[40]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[40])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf42.txt")) PE42 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[41]),
        .bias(biases[41]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[41])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf43.txt")) PE43 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[42]),
        .bias(biases[42]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[42])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf44.txt")) PE44 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[43]),
        .bias(biases[43]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[43])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf45.txt")) PE45 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[44]),
        .bias(biases[44]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[44])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf46.txt")) PE46 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[45]),
        .bias(biases[45]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[45])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf47.txt")) PE47 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[46]),
        .bias(biases[46]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[46])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf48.txt")) PE48 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[47]),
        .bias(biases[47]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[47])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf49.txt")) PE49 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[48]),
        .bias(biases[48]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[48])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf50.txt")) PE50 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[49]),
        .bias(biases[49]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[49])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf51.txt")) PE51 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[50]),
        .bias(biases[50]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[50])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf52.txt")) PE52 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[51]),
        .bias(biases[51]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[51])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf53.txt")) PE53 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[52]),
        .bias(biases[52]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[52])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf54.txt")) PE54 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[53]),
        .bias(biases[53]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[53])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf55.txt")) PE55 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[54]),
        .bias(biases[54]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[54])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf56.txt")) PE56 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[55]),
        .bias(biases[55]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[55])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf57.txt")) PE57 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[56]),
        .bias(biases[56]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[56])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf58.txt")) PE58 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[57]),
        .bias(biases[57]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[57])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf59.txt")) PE59 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[58]),
        .bias(biases[58]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[58])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf60.txt")) PE60 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[59]),
        .bias(biases[59]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[59])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf61.txt")) PE61 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[60]),
        .bias(biases[60]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[60])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf62.txt")) PE62 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[61]),
        .bias(biases[61]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[61])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf63.txt")) PE63 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[62]),
        .bias(biases[62]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[62])
    );

conv2d3x3 #(.weightfile("sqnetparams/conv1/weights/conv1wf64.txt")) PE64 (
        .clk(clk),
        .rst(rst),
        .imgdata1(imgdata1),
        .imgdata2(imgdata2),
        .imgdata3(imgdata3),
        .imgdata4(imgdata4),
        .imgdata5(imgdata5),
        .imgdata6(imgdata6),
        .imgdata7(imgdata7),
        .imgdata8(imgdata8),
        .imgdata9(imgdata9),
        .output_im(output_im[63]),
        .bias(biases[63]),
        .i_data_valid(i_data_valid),
        .currentRdChBuffer(currentRdChBuffer),
        .o_convolved_data_valid(convolved_data_valid[63])
    );

endmodule