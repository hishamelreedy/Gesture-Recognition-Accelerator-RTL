module toplevelv2();
reg clk, rst;
wire [16*9*3-1:0] imgdata;
reg conv1start;
reg [16-1:0] output_im [0:64-1];
wire [16*64-1:0] output_imw;
integer file;
reg i_data_valid;
wire conv1valid;
initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    conv1start = 1;
    // Open Output File
    file = $fopen("opfconv1.txt","w");
end
always #5 clk=~clk;
integer i;
always @(*)
    for (i=0; i<64; i=i+1)
        output_im[i]=output_imw[i*16+:16];
inputimage img (.clk(clk),.rst(rst),.dataout(imgdata),.en(conv1valid));
conv1v2 conv1 (.clk(clk),.rst(rst),.imgdata(imgdata),.i_data_valid(conv1start), .output_imw(output_imw),.o_convolved_data_valid(conv1valid));
integer sentsize = 0;
always@(posedge clk)
begin
   if(conv1valid) begin
       $fwrite(file,"%h\n",output_im[0]);
       sentsize <= sentsize+'d1;
       if(sentsize=='d12321) begin
           i_data_valid = 0;
           //maxpoolvalid = 1;
       end
   end
end
endmodule