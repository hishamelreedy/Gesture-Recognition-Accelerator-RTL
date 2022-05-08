// MaxPool 2D size=3x3 stride=2
module maxpool2d3x3#(parameter datwidth=16,inputsize=111, outputsize=55, inpfile="sqnetparams/conv1/output/conv1opall.txt",outputfile="opf.txt")
                (clk,rst, datain, output_im, address, i_data_valid, o_max_data_valid);
input clk, rst, i_data_valid;
output [datwidth-1:0] output_im;
reg [datwidth-1:0] imgdata [inputsize*inputsize-1:0];
output o_max_data_valid;
input [15:0] datain;
output reg [32-1:0] address;

// Loop on Memory for Reading Data (9 cycles)
reg [7:0] memread;
always @(posedge clk)
begin
    if (rst)
        memread <= 0;
    else
    begin
        if (memread == 8'd8 || i_data_valid == 1'b0)
            memread <= 0;
        else
            memread <= memread + 8'd1;
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
        if (memread == 8'd8) begin
            if(rdCounter == (outputsize-1) || i_data_valid == 1'b0)
                rdCounter <= 0;
            else
                    rdCounter <= rdCounter + 1;
        end
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
        if(rdCounter == (outputsize-1) && memread == 8'd8)
            if (currentRdLineBuffer==inputsize-1|| i_data_valid == 1'b0)
                currentRdLineBuffer <= 8'd0;
            else
                currentRdLineBuffer <= currentRdLineBuffer + 1;
    end
end
// Convolution Operation
// Multiplication
// Mult Regs
reg multDataValid;
reg [datwidth-1:0] multData[8:0];
// Addresses
wire [2*datwidth-1:0] lineaddr;
wire [2*datwidth-1:0] celladdr; 
assign lineaddr = (currentRdLineBuffer*2) * inputsize;
assign celladdr = rdCounter * 2;
always @(*)
begin
    case (memread)
    // Channel X
    // Line 1
    8'd0 : begin
        address = lineaddr+celladdr;
    end
    8'd1: begin
        address = lineaddr+celladdr+1;
    end
    8'd2: begin
        address = lineaddr+celladdr+2;
    end
    // Line 2
    8'd3: begin
        address = lineaddr+inputsize+celladdr;
    end
    8'd4: begin
        address = lineaddr+inputsize+celladdr+1;
    end
    8'd5: begin
        address = lineaddr+inputsize+celladdr+2;
    end
    // Line 3
    8'd6: begin
        address = lineaddr+inputsize+inputsize+celladdr;
    end
    8'd7: begin
        address = lineaddr+inputsize+inputsize+celladdr+1;
    end
    8'd8: begin
        address = lineaddr+inputsize+inputsize+celladdr+2;
    end
    endcase
end
always @(posedge clk)
begin
    case (memread) 
    // Channel X
    // Line 1
    8'd0 : begin
        multData[0] <= datain;
    end
    8'd1: begin
        multData[1] <= datain;
    end
    8'd2: begin
        multData[2] <= datain;
    end
    // Line 2
    8'd3: begin
        multData[3] <= datain;
    end
    8'd4: begin
        multData[4] <= datain;
    end
    8'd5: begin
        multData[5] <= datain;
    end
    // Line 3
    8'd6: begin
        multData[6] <= datain;
    end
    8'd7: begin
        multData[7] <= datain;
    end
    8'd8: begin
        multData[8] <= datain;
    end
    endcase
    // Valid
    multDataValid <= i_data_valid;
end

// MAXer Tree
wire [datwidth-1:0] m1,sum1,m2,sum2,m3,sum3;
wire [datwidth-1:0] mt,totalsum;
reg [datwidth-1:0] channelsum;
// 0,1,2
getmax max1 (multData[0],multData[1], m1);
getmax max2 (m1, multData[2], sum1);
// 3,4,5
getmax max3 (multData[3],multData[4],m2);
getmax max4 (m2, multData[5], sum2);
// 6,7,8
getmax max5 (multData[6],multData[7],m3);
getmax max6 (m3, multData[8], sum3);
// Total
getmax max7 (sum1, sum2, mt);
getmax max8 (mt, sum3, totalsum);

always @(posedge clk)
begin
    if (rst)
        channelsum <= 16'd0;
    else begin
        channelsum <= totalsum;
    end
end

reg [datwidth-1:0] o_convolved_data;
reg o_convolved_data_valid;
always @(posedge clk)
begin
    o_convolved_data <= channelsum;
    o_convolved_data_valid <= multDataValid;
end
reg memreadvalid;
always @(posedge clk)
begin
    memreadvalid <= (memread==8'd8);
end
reg memreadvalidd;
always @(posedge clk)
begin
    memreadvalidd <= memreadvalid;
end
reg memreadvalidd2;
always @(posedge clk)
begin
    memreadvalidd2 <= memreadvalidd;
end
assign o_max_data_valid = o_convolved_data_valid & memreadvalidd2;
assign output_im = o_convolved_data_valid? o_convolved_data : 16'd0;
endmodule