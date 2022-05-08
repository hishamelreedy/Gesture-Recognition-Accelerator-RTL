module poolbanks(clk,rst, wren, rden, address, address2, datain, dataout);
input clk, rst;
reg [15:0] bank [0:64*111*111-1];
input rden;
input wren;
input conv1sel;
input [2:0] firesel;
input [32-1:0] address1;
input [32-1:0] address2;
input [16*64-1:0] datain;
reg [15:0] datainmem[0:63];
output reg [16*64-1:0] dataout;
reg [15:0] dataoutmem[0:63];
integer i;
always @(*)
begin
for (i=0; i<64; i=i+1)
    datainmem[i]<=datain[i*16+:16];
end
reg [31:0] addressoffset;
always @(*)
begin
    case({conv1sel,firesel})
        4'b1000: begin
            addressoffset = 
        end
end
always @(posedge clk)
begin
    if(rst)
        for (i=0; i<64*111*111;i=i+1) begin
            bank[i] <= 16'd0;
        end
    else
        if(wren) begin
            bank[address1] <= datainmem[0];
        end
end
always @(*)
begin
    if (rden) begin
        dataoutmem[0] <= bank1[address2];
    end
end
always @(*)
begin
for (i=0; i<64; i=i+1)
    dataout[i*16+:16]<=dataoutmem[i];
end
endmodule