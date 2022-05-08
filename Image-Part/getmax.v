module getmax (a,b,z);
input [15:0] a,b;
output [15:0] z;

wire [15:0] c;
assign c = a-b;
assign z = (c[15]==1'b1)? b : a;


endmodule