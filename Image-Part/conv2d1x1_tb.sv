module conv2d1x1#(parameter datwidth=16, input_channel=64, inputsize=55, outputsize=55,inpfile="inpf.txt",weightfile="conv1wf1.txt",outputfile="opf.txt")
                ();
reg [datwidth-1:0] imgdata [224*224-1:0];
reg [15:0] kernel;
reg i_clk, i_rst, i_data_valid;
integer f,f1,f1_1,f1_2,f2,file,file_1,file_2,file1,i,j;
initial
begin
    i_clk = 0;
    i_rst = 1;
    f1 = $fopen("input.txt","r");
    f1_1 = $fopen("input1.txt","r");
    f1_2 = $fopen("input2.txt","r");
    // Inserting Image Data into Rom
    // for(i=0;i<224*224;i=i+1)
    //     begin
    //         $fscanf(f1,"%c",imgdata1[i]);
    //         $fscanf(f1_1,"%c",imgdata2[i]);
    //         $fscanf(f1_2,"%c",imgdata3[i]);
    //     end
    $readmemh("input.txt",imgdata1);
    $readmemh("input1.txt",imgdata2);
    $readmemh("input2.txt",imgdata3);

    // Inserting Kernel Data into Rom
    kernel1_1 =  -1;
    kernel1_2 =  -1;    
    kernel1_3 =  -1;
    #10;
    i_rst = 0;
    i_data_valid = 1;

    file = $fopen("output2.txt","w");

end
always #5 i_clk=~i_clk;

reg [1:0] currentRdChBuffer;
// loop on channels
always @(posedge clk)
begin
    if(rst)
    begin
        currentRdChBuffer <= 0;
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

// Convolution Operation

// Multiplication
reg multDataValid;
reg [31:0] multData;
wire [31:0] multDataw;
mul_signed mul1 (kernel[currentRdChBuffer],imgdata1,multDataw);
always @(posedge i_clk)
begin
    // Channel 1
    multData <= multDataw;
    multDataValid <= i_data_valid;
end

// Accumulator
reg [15:0] channelsum;
always @(posedge clk)
begin
    if (rst)
        channelsum <= 0;
    else begin
        if (multDataValid && currentRdChBuffer==2'b01)
            channelsum <= bias+multData;
        else if(multDataValid)
            channelsum <= channelsum + multData;
    end
end

reg [15:0] sumData;
reg sumDataValid;
always @(posedge i_clk)
begin
    sumData <= {channelsum[23:16],channelsum[15:8]};
    sumDataValid <= multDataValid;
end

reg [15:0] o_convolved_data;
reg o_convolved_data_valid;
always @(posedge i_clk)
begin
    o_convolved_data <= sumData;
    //o_convolved_data <= sumData > 0? sumData:16'd0;
    o_convolved_data_valid <= sumDataValid;
end
integer sentsize = 0;
always@(posedge i_clk)
begin
    if(o_convolved_data_valid)
        $fwrite(file,"%d\n",$signed(o_convolved_data));
        sentsize = sentsize+1;
        if(sentsize==224*224+4)
            $stop;
end

endmodule