// Squeeze Net Squeeze Layer
// Input Channels : 64, 128, 256, 384, 512
// Output Filters : 16, 32, 48, 64
// Parallelism 16 Channels 8 Filters
module squeeze1x1(clk, rst, i_data_valid, firesel, imgaddr, pingpongdata,
                  addressf1, addressfiltf1, addressf2, addressfiltf2,
                  addressf3, addressfiltf3, addressf4, addressfiltf4,
                  addressf5, addressfiltf5, addressf6, addressfiltf6,
                  addressf7, addressfiltf7, addressf8, addressfiltf8,
                  biasf1, biasf2, biasf3, biasf4,
                  biasf5, biasf6, biasf7, biasf8,
                  dataf1, dataf2, dataf3, dataf4,
                  dataf5, dataf6, dataf7, dataf8, outvalid,outim);
input clk, rst, i_data_valid;
input [2:0] firesel;
// Weights
output [31:0] addressf1, addressfiltf1, addressf2, addressfiltf2,
              addressf3, addressfiltf3, addressf4, addressfiltf4,
              addressf5, addressfiltf5, addressf6, addressfiltf6,
              addressf7, addressfiltf7, addressf8, addressfiltf8;
input [15:0] biasf1, biasf2, biasf3, biasf4,
             biasf5, biasf6, biasf7, biasf8;
input [16*16-1:0] dataf1, dataf2, dataf3, dataf4,
                  dataf5, dataf6, dataf7, dataf8;
// Img
output [31:0] imgaddr;
input [16*16-1:0] pingpongdata;

// Output Data
output outvalid;
output [16*8-1:0] outim;
wire [15:0] outimw [0:7];
// Choose which Fire Configuration
reg [31:0] inputchannel, chcyc, inputsize,  filtersize, filtcyc;
always @(*)
begin
    case (firesel)
        3'd0:begin
            inputchannel = 32'd64;
            //chcyc = 32'd4;
            inputsize = 32'd55;
            filtersize = 32'd16;
            //filtcyc = 32'd2;
        end
        3'd1:begin
            inputchannel = 32'd128;
            //chcyc = 32'd8;
            inputsize = 32'd55;
            filtersize = 32'd16;
            //filtcyc = 32'd2;
        end
        3'd2:begin
            inputchannel = 32'd128;
            //chcyc = 32'd8;
            inputsize = 32'd27;
            filtersize = 32'd32;
            //filtcyc = 32'd4;
        end
        3'd3:begin
            inputchannel = 32'd256;
            //chcyc = 32'd16;
            inputsize = 32'd27;
            filtersize = 32'd32;
            //filtcyc = 32'd4;
        end
        3'd4:begin
            inputchannel = 32'd256;
            //chcyc = 32'd16;
            inputsize = 32'd13;
            filtersize = 32'd48;
            //filtcyc = 32'd6;
        end
        3'd5:begin
            inputchannel = 32'd384;
            //chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd48;
            //filtcyc = 32'd6;
        end
        3'd6:begin
            inputchannel = 32'd384;
            //chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd64;
            //filtcyc = 32'd8;
        end
        3'd7:begin
            inputchannel = 32'd512;
            //chcyc = 32'd64;
            inputsize = 32'd13;
            filtersize = 32'd64;
            //filtcyc = 32'd8;
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
        if(currentRdChBuffer == inputchannel)
            currentRdChBuffer <= 0;
        else
            currentRdChBuffer <= currentRdChBuffer + 32'd16;
    end
end

reg [31:0] rdCounter;
// loop on cells
always @(posedge clk)
begin
    if(rst)
        rdCounter <= 0;
    else 
    begin
        if (currentRdChBuffer == inputchannel)
            if(rdCounter == inputsize-1)
                rdCounter <= 0;
            else
                rdCounter <= rdCounter + 1;
    end
end

reg [31:0] currentRdLineBuffer;
// loop on lines
always @(posedge clk)
begin
    if(rst)
    begin
        currentRdLineBuffer <= 0;
    end
    else
    begin
        if(rdCounter == inputsize-1 && currentRdChBuffer==inputchannel)
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
        if (currentRdLineBuffer == inputsize-1 && rdCounter == inputsize-1 && currentRdChBuffer==inputchannel)
            if(rdfilt == filtersize)
                rdfilt <= 0;
            else
                rdfilt <= rdfilt + 32'd8;
    end
end
// Address Generator
wire [31-1:0] chaddr, lineaddr, filtaddr,filtoffset;
assign filtoffset = inputsize * inputsize * inputchannel;
assign filtaddr = rdfilt * inputsize * inputsize * inputchannel;
assign chaddr=currentRdChBuffer*inputsize*inputsize;
assign lineaddr = currentRdLineBuffer * inputsize;

// Fetch Squeeze weights from squeeze weights block
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

// Fetch Img data from ping pong mem
assign imgaddr = chaddr+lineaddr+rdCounter;

// PEs
wire [7:0] sqvalid;
wire first;
assign first = (chaddr==32'd0);
// Filter 1
conv2d1x1 PE1 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf1), .bias(biasf1),.firstvalue(first),.o_convolved_data(outimw[0]),.o_convolved_data_valid(sqvalid[0]));
// Filter 2
conv2d1x1 PE2 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf2), .bias(biasf2),.firstvalue(first),.o_convolved_data(outimw[1]),.o_convolved_data_valid(sqvalid[1]));
// Filter 3
conv2d1x1 PE3 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf3), .bias(biasf3),.firstvalue(first),.o_convolved_data(outimw[2]),.o_convolved_data_valid(sqvalid[2]));
// Filter 4
conv2d1x1 PE4 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf4), .bias(biasf4),.firstvalue(first),.o_convolved_data(outimw[3]),.o_convolved_data_valid(sqvalid[3]));
// Filter 5
conv2d1x1 PE5 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf5), .bias(biasf5),.firstvalue(first),.o_convolved_data(outimw[4]),.o_convolved_data_valid(sqvalid[4]));
// Filter 6
conv2d1x1 PE6 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf6), .bias(biasf6),.firstvalue(first),.o_convolved_data(outimw[5]),.o_convolved_data_valid(sqvalid[5]));
// Filter 7
conv2d1x1 PE7 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf7), .bias(biasf7),.firstvalue(first),.o_convolved_data(outimw[6]),.o_convolved_data_valid(sqvalid[6]));
// Filter 8
conv2d1x1 PE8 (.clk(clk), .rst(rst), .i_data_valid(i_data_valid), .imgdata(pingpongdata), .kernel(dataf8), .bias(biasf8),.firstvalue(first),.o_convolved_data(outimw[7]),.o_convolved_data_valid(sqvalid[7]));

assign outvalid = &sqvalid && (currentRdChBuffer==input_channel);

endmodule