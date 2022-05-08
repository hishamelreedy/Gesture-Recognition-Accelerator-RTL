module inputimage(clk, rst, en,dataout);
input clk,rst,en;
output reg [16*9*3-1:0] dataout;
reg [15:0] dataoutmem[26:0];
reg [15:0] img [224*224*3-1:0];
initial begin
$readmemh("inpf.txt",img);
end
reg [7:0] idx;
always @(posedge clk)
begin
    if(rst)
        idx <= 0;
    else if (en)
        idx <= idx + 2;
end
always @(*)
begin
dataoutmem[0] <= img[idx];
dataoutmem[1] <= img[idx+1];
dataoutmem[2] <= img[idx+2];
dataoutmem[3] <= img[idx+224];
dataoutmem[4] <= img[idx+225];
dataoutmem[5] <= img[idx+226];
dataoutmem[6] <= img[idx+448];
dataoutmem[7] <= img[idx+449];
dataoutmem[8] <= img[idx+450];

dataoutmem[9] <= img[idx+224*224];
dataoutmem[10] <= img[idx+1+224*224];
dataoutmem[11] <= img[idx+2+224*224];
dataoutmem[12] <= img[idx+224+224*224];
dataoutmem[13] <= img[idx+225+224*224];
dataoutmem[14] <= img[idx+226+224*224];
dataoutmem[15] <= img[idx+448+224*224];
dataoutmem[16] <= img[idx+449+224*224];
dataoutmem[17] <= img[idx+450+224*224];

dataoutmem[18] <= img[idx+224*224*2];
dataoutmem[19] <= img[idx+1+224*224*2];
dataoutmem[20] <= img[idx+2+224*224*2];
dataoutmem[21] <= img[idx+224+224*224*2];
dataoutmem[22] <= img[idx+225+224*224*2];
dataoutmem[23] <= img[idx+226+224*224*2];
dataoutmem[24] <= img[idx+448+224*224*2];
dataoutmem[25] <= img[idx+449+224*224*2];
dataoutmem[26] <= img[idx+450+224*224*2];
end
integer i;
always @(*)
begin
for (i=0; i<27; i=i+1)
    dataout[i*16+:16]<=dataoutmem[i];
end
endmodule
