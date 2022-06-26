module conv1_tb();
parameter data_width = 16;
wire [9*data_width-1:0] data_out;
reg [data_width-1:0] data_outmem [0:9-1];
wire      full;
wire      empty;
reg [data_width-1:0]  data_in;
reg      clk;
reg      rst;
reg      wr_en;
reg      rd_en;
fifo_conv1 fifo_conv1 (data_out,full,empty,data_in,clk,rst,wr_en,rd_en);
integer i,j;
always @(*)
for (i=0; i<9; i=i+1) begin
    data_outmem[i]<=data_out[i*16+:16];
end

// Input Image
reg [15:0] inpimg [0:224*224*3-1];
initial begin
    $readmemh("../data/inpf.txt",inpimg);
end
always #5 clk = ~clk;
initial begin
    clk = 0;
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    wr_en = 1;
    for (j=0; j<(224*2)+3;j=j+1) begin
        data_in = inpimg[j];
        @(posedge clk);
    end
    wr_en = 0;
    @(posedge clk);
    rd_en = 1;
    @(posedge clk);
    @(posedge clk);
    rd_en=0;
    @(posedge clk);
    wr_en = 1;
    data_in = inpimg[452];
    @(posedge clk);
    wr_en = 0;
    @(posedge clk);
    $stop;
end
// initial begin
//     @(posedge full);
//     $stop;
// end

endmodule