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
    file1 = $fopen("opfpool1r.txt","w");
    
end
always #5 clk=~clk;
// Layer 1 Conv1
reg [15:0] st1mem [0:255];
wire [16*256-1:0] st1w;
wire conv1valid;
wire [16*256-1:0] conv1out;
reg [16-1:0] conv1outmem [0:255];
conv1 st1 (.clk(clk), .rst(rst),.i_data_valid(i_data_valid), .output_imw(st1w[1023:0]), .o_convolved_data_valid(conv1valid));
reg rd_en;
integer i;
always @(*)
begin
for (i=0; i<256; i=i+1)
    st1mem[i]<=st1w[i*16+:16];
end
reg [32-1:0] sentsize = 'd0;
wire [32-1:0] pooladdr;
poolbanks poolbnks (.clk(clk),.rst(rst),.wren(i_data_valid),.rden(maxpoolvalid),.address(sentsize),.address2(pooladdr),.datain(st1w),.dataout(conv1out));
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
wire maxpooloutvalid;
wire [16*64-1:0] maxpoolout;
reg [15:0] maxpooloutmem [0:63];
maxpool2d st2 (.clk(clk),.rst(rst),.i_data_valid(maxpoolvalid),.pooladdr(pooladdr),.inp(conv1out[1023:0]),.maxpoolout(maxpoolout),.maxpoolvalid(maxpooloutvalid));
always @(*)
begin
    for (i=0; i<64; i=i+1)
        maxpooloutmem[i]<=maxpoolout[i*16+:16];
end
integer sentsize1 = 0;
integer maxpoolsize = 55*55;
always@(posedge clk)
begin
   if(maxpoolvalid==0)
        sentsize1 <= 0;
   if(maxpooloutvalid) begin
        $fwrite(file1,"%h\n",maxpooloutmem[0]);
        sentsize1 = sentsize1+1;
       if(sentsize1==55*55)
           $stop;
   end
end
// Ping-Pong Memory
pingpongmem mem (.clk(clk),.rst(rst),.inputsize(maxpoolsize),.wren(maxpooloutvalid),.rden(),.address1(sentsize1),.address2(),.datain(maxpoolout),.dataout());
// Squeeze 1x1
//squeezeweights sqwhts();
endmodule
