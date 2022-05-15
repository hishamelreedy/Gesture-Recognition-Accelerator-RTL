module maxpool2d(clk, rst, i_data_valid, pooladdr, inp,maxpoolout,maxpoolvalid);
input [64*16-1:0] inp;
reg [15:0] inpmem [0:64-1];
output reg [64*16-1:0] maxpoolout;
wire [15:0] maxpooloutmem [0:64-1];
output maxpoolvalid;
wire [63:0] maxpooloutvalid;
output [31:0] pooladdr;
input clk, rst, i_data_valid;
integer i;
always @(*)
begin
for (i=0; i<64; i=i+1)
    inpmem[i]<=inp[i*16+:16];
end
maxpool2d3x3 maxpool (.clk(clk),.rst(rst),.i_data_valid(i_data_valid),.datain(inpmem[0]),.address(pooladdr),.output_im(maxpooloutmem[0]),.o_max_data_valid(maxpooloutvalid[0]));
maxpool2d3x3 maxpool1 (.clk(clk),.rst(rst),.i_data_valid(i_data_valid),.datain(inpmem[1]),.address(pooladdr),.output_im(maxpooloutmem[1]),.o_max_data_valid(maxpooloutvalid[1]));
maxpool2d3x3 maxpool2 (.clk(clk),.rst(rst),.i_data_valid(i_data_valid),.datain(inpmem[2]),.address(pooladdr),.output_im(maxpooloutmem[2]),.o_max_data_valid(maxpooloutvalid[2]));
maxpool2d3x3 maxpool3 (.clk(clk),.rst(rst),.i_data_valid(i_data_valid),.datain(inpmem[3]),.address(pooladdr),.output_im(maxpooloutmem[3]),.o_max_data_valid(maxpooloutvalid[3]));
assign maxpoolvalid=|maxpooloutvalid;
always @(*)
begin
for (i=0; i<64; i=i+1)
    maxpoolout[i*16+:16]<=maxpooloutmem[i];
end
endmodule