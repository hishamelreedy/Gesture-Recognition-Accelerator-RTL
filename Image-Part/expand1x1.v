module expand1x1();
input clk, rst, i_data_valid;
input [2:0] firesel;
// Weights
output [31:0] addressf1, addressfiltf1, addressf2, addressfiltf2,
              addressf3, addressfiltf3, addressf4, addressfiltf4,
              addressf5, addressfiltf5, addressf6, addressfiltf6,
              addressf7, addressfiltf7, addressf8, addressfiltf8,
              addressf9, addressfiltf9, addressf10, addressfiltf10,
              addressf11, addressfiltf11, addressf12, addressfiltf12,
              addressf13, addressfiltf13, addressf14, addressfiltf14,
              addressf15, addressfiltf15, addressf16, addressfiltf16;
input [15:0] biasf1, biasf2, biasf3, biasf4,
             biasf5, biasf6, biasf7, biasf8,
             biasf9, biasf10, biasf11, biasf12,
             biasf13, biasf14, biasf15, biasf16;
input [16*16-1:0] dataf1, dataf2, dataf3, dataf4,
                  dataf5, dataf6, dataf7, dataf8,
                  dataf9, dataf10, dataf11, dataf12,
                  dataf13, dataf14, dataf15, dataf16;
// Img
output [31:0] imgaddr;
input [16*8-1:0] imgdata;

// Output Data
output outvalid;
output [16*16-1:0] outim;
wire [15:0] outimw [0:15];

// Choose which Fire Configuration
reg [31:0] inputchannel, chcyc, inputsize, filtersize, filtcyc;
always @(*)
begin
    case (firesel)
        3'd0:begin
            inputchannel = 32'd16;
            //chcyc = 32'd4;
            inputsize = 32'd55;
            filtersize = 32'd64;
            //filtcyc = 32'd2;
        end
        3'd1:begin
            inputchannel = 32'd128;
            //chcyc = 32'd8;
            inputsize = 32'd55;
            filtersize = 32'd16;
            //filtcyc = 32'd2;
        end
        3'd2:begin
            inputchannel = 32'd128;
            //chcyc = 32'd8;
            inputsize = 32'd27;
            filtersize = 32'd32;
            //filtcyc = 32'd4;
        end
        3'd3:begin
            inputchannel = 32'd256;
            //chcyc = 32'd16;
            inputsize = 32'd27;
            filtersize = 32'd32;
            //filtcyc = 32'd4;
        end
        3'd4:begin
            inputchannel = 32'd256;
            //chcyc = 32'd16;
            inputsize = 32'd13;
            filtersize = 32'd48;
            //filtcyc = 32'd6;
        end
        3'd5:begin
            inputchannel = 32'd384;
            //chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd48;
            //filtcyc = 32'd6;
        end
        3'd6:begin
            inputchannel = 32'd384;
            //chcyc = 32'd32;
            inputsize = 32'd13;
            filtersize = 32'd64;
            //filtcyc = 32'd8;
        end
        3'd7:begin
            inputchannel = 32'd512;
            //chcyc = 32'd64;
            inputsize = 32'd13;
            filtersize = 32'd64;
            //filtcyc = 32'd8;
        end
    endcase
end

endmodule