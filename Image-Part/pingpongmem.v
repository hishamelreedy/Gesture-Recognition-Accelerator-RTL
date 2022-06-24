module pingpongmem(clk, rst, wren, rden, address1, address2,
                    datain, dataout, inputsize);
input clk,rst;
input wren, rden;
input [31:0] inputsize;
input [31:0] address1, address2;
//input [2:0] firesel;
input [64*16-1:0] datain;
output reg [16*16-1:0] dataout;
reg [15:0] datainmem [63:0];
reg [15:0] dataoutmem [16:0];
reg [15:0] datamem [0:128*55*55-1];
// // maxpool1
// reg [15:0] pool1data [0:64*55*55-1]; //193600
// //fire1 mem
// reg [15:0] fire1data [0:128*55*55-1]; //387200
// //fire2 mem
// reg [15:0] fire2data [0:128*27*27-1]; //93312
// //fire3 mem
// reg [15:0] fire3data [0:256*27*27-1]; //186624
// //fire4 mem
// reg [15:0] fire4data [0:256*13*13-1]; //43264
// //fire5 mem
// reg [15:0] fire5data [0:384*13*13-1]; //64896
// //fire6 mem
// reg [15:0] fire6data [0:384*13*13-1]; //64896
// //fire7 mem
// reg [15:0] fire7data [0:512*13*13-1]; //86528
// //fire8 mem
// reg [15:0] fire8data [0:512*13*13-1]; //86528

integer i;
always @(*)
begin
for (i=0; i<64; i=i+1)
    datainmem[i]<=datain[i*16+:16];
end
always @(posedge clk)
if(rst)
    for (i=0; i<64; i=i+1)
        datamem[address1+i*inputsize] <= 16'd0;
else if (wren) begin
    for (i=0; i<64; i=i+1)
        datamem[address1+i*inputsize] <= datainmem[i];
end
always @(posedge clk)
if (rden) begin
    for (i=0;i<16;i=i+1)
        dataoutmem[i] <= datamem[address2+(i*55*55)];
end
always @(*)
begin
for (i=0; i<16; i=i+1)
    dataout[i*16+:16]<=dataoutmem[i];
end
endmodule