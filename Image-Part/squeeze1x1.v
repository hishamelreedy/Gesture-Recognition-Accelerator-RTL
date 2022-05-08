// Squeeze Net Squeeze Layer
// Input Channels : 64, 128, 256, 384, 512
// Output Filters : 16, 32, 48, 64
// Parallelism 16 Channels 8 Filters
module squeeze1x1();
reg clk, rst, i_data_valid;
reg [2:0] firesel;
reg [31:0] inputchannel, chcyc, inputsize,  filtersize, filtcyc;
wire [2*16-1:0] addressf1, addressfiltf1, addressf2, addressfiltf2,
                        addressf3, addressfiltf3, addressf4, addressfiltf4,
                        addressf5, addressfiltf5, addressf6, addressfiltf6,
                        addressf7, addressfiltf7, addressf8, addressfiltf8;
integer file;
initial
begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    i_data_valid = 1;
    // Choose Fire1
    firesel = 32'd0;
    file = $fopen("opfsqueeze1x1.txt","w");

end
always #5 clk=~clk;
// Choose which Fire Configuration
always @(*)
begin
    case (firesel)
        3'd0:begin
            inputchannel = 32'd64;
            chcyc = 32'd4;
            inputsize = 32'd55;
            filtersize = 32'd16;
            filtcyc = 32'd2;
        end
        3'd1:begin
            inputchannel = 32'd128;
            chcyc = 32'd8;
            inputsize = 32'd55;
            filtersize = 32'd16;
            filtcyc = 32'd2;
        end
        3'd2:begin
            inputchannel = 32'd128;
            chcyc = 32'd8;
            inputsize = 32'd27;
            filtersize = 32'd32;
            filtcyc = 32'd4;
        end
        3'd3:begin
            inputchannel = 32'd256;
            chcyc = 32'd16;
            inputsize = 32'd27;
            filtersize = 32'd32;
            filtcyc = 32'd4;
        end
        3'd4:begin
            inputchannel = 32'd256;
            chcyc = 32'd16;
            inputsize = 32'd13;
            filtersize = 32'd48;
            filtcyc = 32'd6;
        end
        3'd5:begin
            inputchannel = 32'd384;
            chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd48;
            filtcyc = 32'd6;
        end
        3'd6:begin
            inputchannel = 32'd384;
            chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd64;
            filtcyc = 32'd8;
        end
        3'd7:begin
            inputchannel = 32'd512;
            chcyc = 32'd64;
            inputsize = 32'd13;
            filtersize = 32'd64;
            filtcyc = 32'd8;
        end
    endcase
end
// Input

// Controllers
reg [31:0] currentRdChBuffer;
// loop on channels
always @(posedge clk)
begin
    if(rst)
    begin
        currentRdChBuffer <= 0;
    end
    else
    begin
        if(currentRdChBuffer == inputchannel-1)
            currentRdChBuffer <= 0;
        else
            currentRdChBuffer <= currentRdChBuffer + chcyc;
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
        if (currentRdChBuffer == inputchannel-1)
            if(rdCounter == inputsize-1)
                rdCounter <= 0;
            else
                rdCounter <= rdCounter + 1;
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
        if(rdCounter == inputsize-1 && currentRdChBuffer==inputchannel-1)
            if (currentRdLineBuffer==inputsize-1)
                currentRdLineBuffer <= 0;
            else
                currentRdLineBuffer <= currentRdLineBuffer + 1;
    end
end

reg [31:0] rdfilt;
// loop on filters
always @(posedge clk)
begin
    if(rst)
    begin
        rdfilt <= 0;
    end
    else
    begin
        if (currentRdLineBuffer == inputsize-1 && rdCounter == inputsize-1 && currentRdChBuffer==inputchannel-1)
            if(rdfilt == filtersize-1)
                rdfilt <= 0;
            else
                rdfilt <= rdfilt + filtcyc;
    end
end
// Address Generator
wire [2*16-1:0] chaddr, lineaddr, filtaddr,filtoffset;
assign filtoffset = inputsize * inputsize * inputchannel;
assign filtaddr = rdfilt * inputsize * inputsize * inputchannel;
assign chaddr=currentRdChBuffer*inputsize*inputsize;
assign lineaddr = currentRdLineBuffer * inputsize;
assign addressf1 = filtaddr+chaddr+lineaddr+rdCounter;
assign addressfiltf1 = rdfilt;
assign addressf2 = filtaddr+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf2 = rdfilt+1;
assign addressf3 = filtaddr+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf3 = rdfilt+2;
assign addressf4 = filtaddr+filtoffset+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf4 = rdfilt+3;
assign addressf5 = filtaddr+filtoffset+filtoffset+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf5 = rdfilt+4;
assign addressf6=filtaddr+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf6 = rdfilt+5;
assign addressf7=filtaddr+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf7 = rdfilt+6;
assign addressf8=filtaddr+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+filtoffset+chaddr+lineaddr+rdCounter;
assign addressfiltf8 = rdfilt+7;
// PEs
// Filter 1
conv2d1x1 PE1 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf1), .bias(biasf1));
// Filter 2
conv2d1x1 PE2 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf2), .bias(biasf2));
// Filter 3
conv2d1x1 PE3 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf3), .bias(biasf3));
// Filter 4
conv2d1x1 PE4 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf4), .bias(biasf4));
// Filter 5
conv2d1x1 PE5 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf5), .bias(biasf5));
// Filter 6
conv2d1x1 PE6 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf6), .bias(biasf6));
// Filter 7
conv2d1x1 PE7 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf7), .bias(biasf7));
// Filter 8
conv2d1x1 PE8 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), imgdata, .kernel(dataf8), .bias(biasf8));

// Output
integer sentsize = 0;
always@(posedge clk)
begin
    if(o_convolved_data_valid)
        $fwrite(file,"%d\n",$signed(o_convolved_data));
        sentsize = sentsize+1;
        if(sentsize==inputsize*inputsize+1)
            $stop;
end
endmodule