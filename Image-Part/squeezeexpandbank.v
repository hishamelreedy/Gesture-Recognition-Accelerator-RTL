module squeezeexpandbank();
reg [15:0] bank1 [0:111*111-1];
reg [15:0] bank2 [0:111*111-1];
reg [15:0] bank3 [0:111*111-1];
reg [15:0] bank4 [0:111*111-1];
reg [15:0] bank5 [0:111*111-1];
reg [15:0] bank6 [0:111*111-1];
reg [15:0] bank7 [0:111*111-1];
reg [15:0] bank8 [0:111*111-1];
reg rden, wren, clk, rst;
reg [16*8-1:0] datain;
reg [15:0] datainmem [0:7];
wire [16*16-1:0] dataout;
reg [15:0] dataoutmem [0:7];
reg [31:0] address1,address2;

integer i;
always @(posedge clk)
if (wren) begin
    bank1[address1] <= datainmem[0]; 
    bank2[address1] <= datainmem[1];
    bank3[address1] <= datainmem[2];
    bank4[address1] <= datainmem[3];
    bank5[address1] <= datainmem[4];
    bank6[address1] <= datainmem[5];
    bank7[address1] <= datainmem[6];
    bank8[address1] <= datainmem[7];
end

always @(*)
begin
    if (rden) begin
        dataoutmem[0] = bank1[address2];
        dataoutmem[1] = bank2[address2];
        dataoutmem[2] = bank3[address2];
        dataoutmem[3] = bank4[address2];
        dataoutmem[4] = bank5[address2];
        dataoutmem[5] = bank6[address2];
        dataoutmem[6] = bank7[address2];
        dataoutmem[7] = bank8[address2];
    end
end

endmodule