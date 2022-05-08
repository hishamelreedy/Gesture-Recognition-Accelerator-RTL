// Module: Squeeze Weights
// Parallelism 16 Channels 8 Filters
module squeezeweights(firesel, addressf1, dataf1, addressfiltf1, biasf1,
                               addressf2, dataf2, addressfiltf2, biasf2,
                               addressf3, dataf3, addressfiltf3, biasf3,
                               addressf4, dataf4, addressfiltf4, biasf4,
                               addressf5, dataf5, addressfiltf5, biasf5,
                               addressf6, dataf6, addressfiltf6, biasf6,
                               addressf7, dataf7, addressfiltf7, biasf7,
                               addressf8, dataf8, addressfiltf8, biasf8
                               );
input [2:0] firesel;

input [32*16-1:0] addressf1;
output [16*16-1:0] dataf1;
input [32-1:0] addressfiltf1;
output reg [15:0] biasf1;
reg [32-1:0] addressmemf1 [0:16-1];
reg [16-1:0] datamemf1 [0:16-1];

input [32*16-1:0] addressf2;
output [16*16-1:0] dataf2;
input [32-1:0] addressfiltf2;
output reg [15:0] biasf2;
reg [32-1:0] addressmemf2 [0:16-1];
reg [16-1:0] datamemf2 [0:16-1];

input [32*16-1:0] addressf3;
output [16*16-1:0] dataf3;
input [32-1:0] addressfiltf3;
output reg [15:0] biasf3;
reg [32-1:0] addressmemf3 [0:16-1];
reg [16-1:0] datamemf3 [0:16-1];

input [32*16-1:0] addressf4;
output [16*16-1:0] dataf4;
input [32-1:0] addressfiltf4;
output reg [15:0] biasf4;
reg [32-1:0] addressmemf4 [0:16-1];
reg [16-1:0] datamemf4 [0:16-1];

input [32*16-1:0] addressf5;
output [16*16-1:0] dataf5;
input [32-1:0] addressfiltf5;
output reg [15:0] biasf5;
reg [32-1:0] addressmemf5 [0:16-1];
reg [16-1:0] datamemf5 [0:16-1];

input [32*16-1:0] addressf6;
output [16*16-1:0] dataf6;
input [32-1:0] addressfiltf6;
output reg [15:0] biasf6;
reg [32-1:0] addressmemf6 [0:16-1];
reg [16-1:0] datamemf6 [0:16-1];

input [32*16-1:0] addressf7;
output [16*16-1:0] dataf7;
input [32-1:0] addressfiltf7;
output reg [15:0] biasf7;
reg [32-1:0] addressmemf7 [0:16-1];
reg [16-1:0] datamemf7 [0:16-1];

input [32*16-1:0] addressf8;
output [16*16-1:0] dataf8;
input [32-1:0] addressfiltf8;
output reg [15:0] biasf8;
reg [32-1:0] addressmemf8 [0:16-1];
reg [16-1:0] datamemf8 [0:16-1];

// Fire 1
reg [15:0] weightsfire1 [16*64*1*1-1:0];
reg [15:0] biasfire1 [16-1:0];
// Fire 2
reg [15:0] weightsfire2 [16*128*1*1-1:0];
reg [15:0] biasfire2 [16-1:0];
// Fire 3
reg [15:0] weightsfire3 [32*128*1*1-1:0];
reg [15:0] biasfire3 [32-1:0];
// Fire 4
reg [15:0] weightsfire4 [32*256*1*1-1:0];
reg [15:0] biasfire4 [32-1:0];
// Fire 5
reg [15:0] weightsfire5 [48*256*1*1-1:0];
reg [15:0] biasfire5 [48-1:0];
// Fire 6
reg [15:0] weightsfire6 [48*384*1*1-1:0];
reg [15:0] biasfire6 [48-1:0];
// Fire 7
reg [15:0] weightsfire7 [64*384*1*1-1:0];
reg [15:0] biasfire7 [64-1:0];
// Fire 8
reg [15:0] weightsfire8 [64*512*1*1-1:0];
reg [15:0] biasfire8 [64-1:0];
integer i;
// Memory Banks 16 mem [Channels] * 8 mem [Filters]
always @(*)
begin
case (firesel)
3'b000:begin
    // Fire 1
        // Biases
        biasf1 = biasfire1[addressfiltf1];
        biasf2 = biasfire1[addressfiltf2];
        biasf3 = biasfire1[addressfiltf3];
        biasf4 = biasfire1[addressfiltf4];
        biasf5 = biasfire1[addressfiltf5];
        biasf6 = biasfire1[addressfiltf6];
        biasf7 = biasfire1[addressfiltf7];
        biasf8 = biasfire1[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire1[addressmemf1[i]];
            datamemf2[i] = weightsfire1[addressmemf2[i]];
            datamemf3[i] = weightsfire1[addressmemf3[i]];
            datamemf4[i] = weightsfire1[addressmemf4[i]];
            datamemf5[i] = weightsfire1[addressmemf5[i]];
            datamemf6[i] = weightsfire1[addressmemf6[i]];
            datamemf7[i] = weightsfire1[addressmemf7[i]];
            datamemf8[i] = weightsfire1[addressmemf8[i]];
        end
end
3'b001:begin
    // Fire 2
        // Biases
        biasf1 = biasfire2[addressfiltf1];
        biasf2 = biasfire2[addressfiltf2];
        biasf3 = biasfire2[addressfiltf3];
        biasf4 = biasfire2[addressfiltf4];
        biasf5 = biasfire2[addressfiltf5];
        biasf6 = biasfire2[addressfiltf6];
        biasf7 = biasfire2[addressfiltf7];
        biasf8 = biasfire2[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire2[addressmemf1[i]];
            datamemf2[i] = weightsfire2[addressmemf2[i]];
            datamemf3[i] = weightsfire2[addressmemf3[i]];
            datamemf4[i] = weightsfire2[addressmemf4[i]];
            datamemf5[i] = weightsfire2[addressmemf5[i]];
            datamemf6[i] = weightsfire2[addressmemf6[i]];
            datamemf7[i] = weightsfire2[addressmemf7[i]];
            datamemf8[i] = weightsfire2[addressmemf8[i]];
        end
end
3'b010:begin
    // Fire 3
        // Biases
        biasf1 = biasfire3[addressfiltf1];
        biasf2 = biasfire3[addressfiltf2];
        biasf3 = biasfire3[addressfiltf3];
        biasf4 = biasfire3[addressfiltf4];
        biasf5 = biasfire3[addressfiltf5];
        biasf6 = biasfire3[addressfiltf6];
        biasf7 = biasfire3[addressfiltf7];
        biasf8 = biasfire3[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire3[addressmemf1[i]];
            datamemf2[i] = weightsfire3[addressmemf2[i]];
            datamemf3[i] = weightsfire3[addressmemf3[i]];
            datamemf4[i] = weightsfire3[addressmemf4[i]];
            datamemf5[i] = weightsfire3[addressmemf5[i]];
            datamemf6[i] = weightsfire3[addressmemf6[i]];
            datamemf7[i] = weightsfire3[addressmemf7[i]];
            datamemf8[i] = weightsfire3[addressmemf8[i]];
        end
end
3'b011:begin
    // Fire 4
        // Biases
        biasf1 = biasfire4[addressfiltf1];
        biasf2 = biasfire4[addressfiltf2];
        biasf3 = biasfire4[addressfiltf3];
        biasf4 = biasfire4[addressfiltf4];
        biasf5 = biasfire4[addressfiltf5];
        biasf6 = biasfire4[addressfiltf6];
        biasf7 = biasfire4[addressfiltf7];
        biasf8 = biasfire4[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire4[addressmemf1[i]];
            datamemf2[i] = weightsfire4[addressmemf2[i]];
            datamemf3[i] = weightsfire4[addressmemf3[i]];
            datamemf4[i] = weightsfire4[addressmemf4[i]];
            datamemf5[i] = weightsfire4[addressmemf5[i]];
            datamemf6[i] = weightsfire4[addressmemf6[i]];
            datamemf7[i] = weightsfire4[addressmemf7[i]];
            datamemf8[i] = weightsfire4[addressmemf8[i]];
        end
end
3'b100:begin
    // Fire 5
        // Biases
        biasf1 = biasfire5[addressfiltf1];
        biasf2 = biasfire5[addressfiltf2];
        biasf3 = biasfire5[addressfiltf3];
        biasf4 = biasfire5[addressfiltf4];
        biasf5 = biasfire5[addressfiltf5];
        biasf6 = biasfire5[addressfiltf6];
        biasf7 = biasfire5[addressfiltf7];
        biasf8 = biasfire5[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire5[addressmemf1[i]];
            datamemf2[i] = weightsfire5[addressmemf2[i]];
            datamemf3[i] = weightsfire5[addressmemf3[i]];
            datamemf4[i] = weightsfire5[addressmemf4[i]];
            datamemf5[i] = weightsfire5[addressmemf5[i]];
            datamemf6[i] = weightsfire5[addressmemf6[i]];
            datamemf7[i] = weightsfire5[addressmemf7[i]];
            datamemf8[i] = weightsfire5[addressmemf8[i]];
        end
end
3'b101:begin
    // Fire 6
        // Biases
        biasf1 = biasfire6[addressfiltf1];
        biasf2 = biasfire6[addressfiltf2];
        biasf3 = biasfire6[addressfiltf3];
        biasf4 = biasfire6[addressfiltf4];
        biasf5 = biasfire6[addressfiltf5];
        biasf6 = biasfire6[addressfiltf6];
        biasf7 = biasfire6[addressfiltf7];
        biasf8 = biasfire6[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire6[addressmemf1[i]];
            datamemf2[i] = weightsfire6[addressmemf2[i]];
            datamemf3[i] = weightsfire6[addressmemf3[i]];
            datamemf4[i] = weightsfire6[addressmemf4[i]];
            datamemf5[i] = weightsfire6[addressmemf5[i]];
            datamemf6[i] = weightsfire6[addressmemf6[i]];
            datamemf7[i] = weightsfire6[addressmemf7[i]];
            datamemf8[i] = weightsfire6[addressmemf8[i]];
        end
end
3'b110:begin
    // Fire 7
        // Biases
        biasf1 = biasfire7[addressfiltf1];
        biasf2 = biasfire7[addressfiltf2];
        biasf3 = biasfire7[addressfiltf3];
        biasf4 = biasfire7[addressfiltf4];
        biasf5 = biasfire7[addressfiltf5];
        biasf6 = biasfire7[addressfiltf6];
        biasf7 = biasfire7[addressfiltf7];
        biasf8 = biasfire7[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire7[addressmemf1[i]];
            datamemf2[i] = weightsfire7[addressmemf2[i]];
            datamemf3[i] = weightsfire7[addressmemf3[i]];
            datamemf4[i] = weightsfire7[addressmemf4[i]];
            datamemf5[i] = weightsfire7[addressmemf5[i]];
            datamemf6[i] = weightsfire7[addressmemf6[i]];
            datamemf7[i] = weightsfire7[addressmemf7[i]];
            datamemf8[i] = weightsfire7[addressmemf8[i]];
        end
end
3'b111:begin
    // Fire 8
        // Biases
        biasf1 = biasfire8[addressfiltf1];
        biasf2 = biasfire8[addressfiltf2];
        biasf3 = biasfire8[addressfiltf3];
        biasf4 = biasfire8[addressfiltf4];
        biasf5 = biasfire8[addressfiltf5];
        biasf6 = biasfire8[addressfiltf6];
        biasf7 = biasfire8[addressfiltf7];
        biasf8 = biasfire8[addressfiltf8];
        // Weights
        for (i=0; i<16; i=i+1) begin
            datamemf1[i] = weightsfire8[addressmemf1[i]];
            datamemf2[i] = weightsfire8[addressmemf2[i]];
            datamemf3[i] = weightsfire8[addressmemf3[i]];
            datamemf4[i] = weightsfire8[addressmemf4[i]];
            datamemf5[i] = weightsfire8[addressmemf5[i]];
            datamemf6[i] = weightsfire8[addressmemf6[i]];
            datamemf7[i] = weightsfire8[addressmemf7[i]];
            datamemf8[i] = weightsfire8[addressmemf8[i]];
        end
end
endcase
end


endmodule