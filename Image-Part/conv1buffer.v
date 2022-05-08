module conv1buffer(data_out,full,empty,data_in,clk,rst_a,wr_en,rd_en);
 
//---------------parameters declaration
   parameter data_width    = 16;
   parameter ram_depth     = 111*111;
   parameter address_width = $clog2(ram_depth);


//--------------input output port declaration
   output reg [9*data_width-1:0] data_out;
   output      full;
   output      empty;
   input [data_width-1:0]  data_in;
   input      clk;
   input      rst_a;
   input      wr_en;
   input      rd_en;

//--------------internal register declaration
   reg [address_width-1:0]    wr_pointer;
   reg [address_width-1:0]    rd_pointer;
   reg [address_width :0]     status_count;
   wire [data_width-1:0]      data_ram ;
   reg [data_width-1:0] mem [0:ram_depth-1];

 
//--------------wr_pointer pointing to write address
   always @ (posedge clk,posedge rst_a)
     begin
  if(rst_a)
   wr_pointer = -2;
  else
   if(wr_en)
    wr_pointer = wr_pointer+1;
 end
//-------------rd_pointer points to read address
   always @ (posedge clk,posedge rst_a)
     begin
  if(rst_a)
   rd_pointer = 0;
  else
   if(rd_en)
    rd_pointer = rd_pointer+1;
 end
//-------------read from FIFO
   always @ (posedge clk,posedge rst_a)
    begin
  if(rst_a)
   data_out=0;
  else
   if(rd_en)
    data_out={  data_ram[rd_pointer],data_ram[rd_pointer+1],data_ram[rd_pointer+2],
                data_ram[rd_pointer+224],data_ram[rd_pointer+1+224],data_ram[rd_pointer+2+224],
                data_ram[rd_pointer+448],data_ram[rd_pointer+1+448],data_ram[rd_pointer+2+448]};
    end

//--------------Status pointer for full and empty checking
   always @ (posedge clk,posedge rst_a)
    begin
  if(rst_a)
   status_count = 0;
  else
   if(wr_en && !rd_en && (status_count != ram_depth))
    status_count = status_count + 1;
  else
   if(rd_en && !wr_en && (status_count != 0))
    status_count = status_count - 1;
    end // always @ (posedge clk,posedge rst_a)


   assign full = (status_count == (ram_depth));
   assign empty = (status_count == 0);
 //-------------Memory--------------
 always @(posedge clk)
 begin
     if(wr_en)
        mem[wr_pointer] <= data_in;
 end
//    memory_16x4 #(data_width,address_width,ram_depth) u1 
//                (.address_1(wr_pointer),.address_2(rd_pointer),.data_1(data_in),.data_2(data_ram),.wr_en1(wr_en),.rd_en2(rd_en),.clk(clk));


endmodule
