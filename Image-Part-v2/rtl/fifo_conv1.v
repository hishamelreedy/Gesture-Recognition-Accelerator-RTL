module fifo_conv1(data_out,full,empty,data_in,clk,rst,wr_en,rd_en);
 
//---------------parameters declaration
    parameter w = 224;
    parameter data_width    = 16;
    parameter ram_depth     = (2*w)+3;
    parameter address_width = $clog2(ram_depth);


//--------------input output port declaration
   output reg [9*data_width-1:0] data_out;
   output      full;
   output      empty;
   input [data_width-1:0]  data_in;
   input      clk;
   input      rst;
   input      wr_en;
   input      rd_en;

//--------------internal register declaration
   reg [address_width-1:0]    wr_pointer;
   reg [address_width-1:0]    rd_pointer;
   reg [address_width :0]     status_count;
   reg [data_width-1:0] mem [0:ram_depth-1];

 
//--------------wr_pointer pointing to write address
   always @ (posedge clk)
     begin
  if(rst)
   wr_pointer <= -1;
  else
   if(wr_en)
    if(wr_pointer == 'd452)
        wr_pointer <= 'd0;
    else
        wr_pointer <= wr_pointer+1;
 end
//-------------rd_pointer points to read address
   always @ (posedge clk)
     begin
  if(rst)
   rd_pointer <= 0;
  else
   if(rd_en)
    if (rd_pointer == 'd452)
        rd_pointer <= 'd0;
    else
        rd_pointer <= rd_pointer+1;
 end
//-------------read from FIFO
   always @ (posedge clk)
    begin
  if(rst)
   data_out=0;
  else
   if(rd_en)
    data_out={  mem[0],mem[1],mem[2],
                mem[224],mem[225],mem[226],
                mem[448],mem[449],mem[450]};
    end

//--------------Status pointer for full and empty checking
   always @ (posedge clk)
    begin
  if(rst)
   status_count = 0;
  else
   if(wr_en && !rd_en && (status_count != ram_depth))
    status_count = status_count + 1;
  else
   if(rd_en && !wr_en && (status_count != 0))
    status_count = status_count - 1;
    end


   assign full = (status_count == (ram_depth));
   assign empty = (status_count == 0);
 //-------------Memory--------------
 always @(posedge clk)
 begin
     if(wr_en)
        mem[wr_pointer] <= data_in;
 end

endmodule
