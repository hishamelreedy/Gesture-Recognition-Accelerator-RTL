module pingpongmem(clk, rst, wren, rden, address1, address2,
                    firesel, datain, dataout);
input clk,rst;
input wren, rden;
input [31:0] address1, address2;
input [2:0] firesel;
input [64*16-1:0] datain;
output reg [16*16-1:0] dataout;
reg [15:0] datainmem [63:0];
reg [15:0] dataoutmem [16:0];
// maxpool1
reg [15:0] pool1data [0:64*55*55-1];
//fire1 mem
reg [15:0] fire1data [0:128*55*55-1];
//fire2 mem
reg [15:0] fire2data [0:128*27*27-1];
//fire3 mem
reg [15:0] fire3data [0:256*27*27-1];
//fire4 mem
reg [15:0] fire4data [0:256*13*13-1];
//fire5 mem
reg [15:0] fire5data [0:384*13*13-1];
//fire6 mem
reg [15:0] fire6data [0:384*13*13-1];
//fire7 mem
reg [15:0] fire7data [0:512*13*13-1];
//fire8 mem
reg [15:0] fire8data [0:512*13*13-1];

integer i;
always @(*)
begin
for (i=0; i<64; i=i+1)
    datainmem[i]<=datain[i*16+:16];
end
always @(posedge clk)
if (wren) begin
    for (i=0; i<64; i=i+1)
        data[wrpntr] <= datain;
    if(wrpntr=='d63999)
        wrpntr <= 0;
    else
        wrpntr <= wrpntr+64; 
end
always @(posedge clk)
if (rden) begin
    for (i=0;i<16;i=i+1)
        dataoutmem[i] <= data[wrpntr+i];
    if(rdpntr=='d63999)
        rdpntr <= 0;
    else
        rdpntr <= rdpntr + 16;
end
always @(*)
begin
for (i=0; i<16; i=i+1)
    dataout[i*16+:16]<=dataoutmem[i];
end
endmodule