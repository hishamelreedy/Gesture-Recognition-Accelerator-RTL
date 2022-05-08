module toplevel();
reg clk, rst;
integer file,file1;
reg i_data_valid;
reg maxpoolvalid;
initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    i_data_valid = 1;
    maxpoolvalid = 0;
    // Open Output File
    file = $fopen("opfconv1.txt","w");
    file1 = $fopen("opfpool1.txt","w");
    
end
always #5 clk=~clk;
// Layer 1 Conv1
reg [15:0] st1mem [0:63];
reg [16*64-1:0] st1w;
wire conv1valid;
reg [16*64-1:0] conv1out;
reg [16-1:0] conv1outmem [0:63];
conv1 st1 (.clk(clk), .rst(rst),.i_data_valid(i_data_valid), .output_imw(st1w), .o_convolved_data_valid(conv1valid));
reg rd_en;
integer i;
always @(*)
begin
for (i=0; i<64; i=i+1)
    st1mem[i]<=st1w[i*16+:16];
end
reg [32-1:0] sentsize = 'd0;
reg [32-1:0] pooladdr;
conv1banks conv1bnks (.clk(clk),.rst(rst),.wren(i_data_valid),.rden(maxpoolvalid),.address(sentsize),.address2(pooladdr),.datain(st1w),.dataout(conv1out));
always@(posedge clk)
begin
   if(conv1valid) begin
       $fwrite(file,"%h\n",st1mem[0]);
       sentsize <= sentsize+'d1;
       if(sentsize==111*111) begin
           i_data_valid = 0;
           maxpoolvalid = 1;
       end
   end
end
// Layer 2 MaxPool
wire [63:0] maxpooloutvalid;
wire [15:0] maxpoolout [0:63];
always @(*)
begin
for (i=0; i<64; i=i+1)
    conv1outmem[i]<=conv1out[i*16+:16];
end
maxpool2d3x3 maxpool (.clk(clk),.rst(rst),.i_data_valid(maxpoolvalid),.datain(conv1outmem[0]),.address(pooladdr),.output_im(maxpoolout[0]),.o_max_data_valid(maxpooloutvalid[0]));
maxpool2d3x3 maxpool1 (.clk(clk),.rst(rst),.i_data_valid(maxpoolvalid),.datain(conv1outmem[1]),.address(pooladdr),.output_im(maxpoolout[1]),.o_max_data_valid(maxpooloutvalid[1]));
maxpool2d3x3 maxpool2 (.clk(clk),.rst(rst),.i_data_valid(maxpoolvalid),.datain(conv1outmem[2]),.address(pooladdr),.output_im(maxpoolout[2]),.o_max_data_valid(maxpooloutvalid[2]));
maxpool2d3x3 maxpool3 (.clk(clk),.rst(rst),.i_data_valid(maxpoolvalid),.datain(conv1outmem[3]),.address(pooladdr),.output_im(maxpoolout[3]),.o_max_data_valid(maxpooloutvalid[3]));

integer sentsize1 = 0;
always@(posedge clk)
begin
   if(maxpoolvalid==0)
        sentsize1 <= 0;
   if(maxpooloutvalid) begin
        $fwrite(file1,"%h\n",maxpoolout[0]);
        sentsize1 = sentsize1+1;
       if(sentsize1==55*55)
           $stop;
   end
end
// Ping-Pong Memory

// Squeeze 1x1
squeezeweights sqwhts();
endmodule
