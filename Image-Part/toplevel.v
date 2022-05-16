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
reg [31:0] imgaddr;
wire [16*16-1:0] pingpongdata;
reg [31:0] sqadf1, sqadff1, sqadff2, sqadff2,
            sqadf3, sqadff3, sqadf4, sqadff4,
            sqadf5, sqadff5, sqadf6, sqadff6,
            sqadf7, sqadff7, sqadf8, sqadff8;
wire [16*16-1:0] sqdatf1, sqdatf2, sqdatf3, sqdatf4,
                sqdatf5, sqdatf6, sqdatf7, sqdatf8;
wire [15-1:0] sqbias1, sqbias2, sqbias3, sqbias4, sqbias5, sqbias6, sqbias7, sqbias8;
pingpongmem mem (.clk(clk),.rst(rst),.inputsize(maxpoolsize),.wren(maxpooloutvalid),.rden(squeezevalid),.address1(sentsize1),.address2(imgaddr),.datain(maxpoolout),.dataout(pingpongdata));
// Squeeze 1x1
reg [2:0] firesel;
wire [16*8-1:0] sqout;
reg [15:0] sqoutmem [0:7];
squeezeweights sqwhts(.firesel(firesel),.addressf1(sqadf1), .dataf1(sqdatf1), .addressfiltf1(sqadff1), .biasf1(sqbias1),
                               .addressf2(sqadf2), .dataf2(sqdatf2), .addressfiltf2(sqadff2), .biasf2(sqbias2),
                               .addressf3(sqadf3), .dataf3(sqdatf3), .addressfiltf3(sqadff3), .biasf3(sqbias3),
                               .addressf4(sqadf4), .dataf4(sqdatf4), .addressfiltf4(sqadff4), .biasf4(sqbias4),
                               .addressf5(sqadf5), .dataf5(sqdatf5), .addressfiltf5(sqadff5), .biasf5(sqbias5),
                               .addressf6(sqadf6), .dataf6(sqdatf6), .addressfiltf6(sqadff6), .biasf6(sqbias6),
                               .addressf7(sqadf7), .dataf7(sqdatf7), .addressfiltf7(sqadff7), .biasf7(sqbias7),
                               .addressf8(sqadf8), .dataf8(sqdatf8), .addressfiltf8(sqadff8), .biasf8(sqbias8)
                               );
reg squeezevalid;
wire squeezeoutvalid;
squeeze1x1 st3 (.clk(clk), .rst(rst), .i_data_valid(squeezevalid), .firesel(firesel), .imgaddr(imgaddr), .pingpongdata(pingpongdata),
                  .addressf1(sqadf1), .addressfiltf1(sqadff1), .addressf2(sqadf2), .addressfiltf2(sqadff2),
                  .addressf3(sqadf3), .addressfiltf3(sqadff3), .addressf4(sqadf4), .addressfiltf4(sqadff4),
                  .addressf5(sqadf5), .addressfiltf5(sqadff5), .addressf6(sqadf6), .addressfiltf6(sqadff6),
                  .addressf7(sqadf7), .addressfiltf7(sqadff6), .addressf8(sqadf7), .addressfiltf8(sqadff7),
                  .biasf1(sqbias1), .biasf2(sqbias2), .biasf3(sqbias3), .biasf4(sqbias4),
                  .biasf5(sqbias5), .biasf6(sqbias6), .biasf7(sqbias7), .biasf8(sqbias8),
                  .dataf1(sqdatf1), .dataf2(sqdatf2), .dataf3(sqdatf3), .dataf4(sqdatf4),
                  .dataf5(sqdatf5), .dataf6(sqdatf6), .dataf7(sqdatf7), .dataf8(sqdatf8),.outvalid(squeezeoutvalid),.outim(sqout));

integer file3;
initial
begin
    // Choose Fire1
    firesel = 3'd0;
    file3 = $fopen("opfire1sq1x1.txt","w");
end
// Output
integer sentsize2 = 0;
always@(posedge clk)
begin
    if(squeezeoutvalid)
        $fwrite(file3,"%d\n",$signed(o_convolved_data));
        sentsize2 = sentsize2+1;
        if(sentsize2==inputsize*inputsize+1)
            $stop;
end

endmodule
