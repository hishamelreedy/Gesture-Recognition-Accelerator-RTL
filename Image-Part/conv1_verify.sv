module conv1_verify();
// Input
logic [15:0] img [0:224*224*3-1];
// Fixed Point Signed Multiplier
logic [15:0] a,b;
logic [31:0] z;
mul_signed mul1 (a,b,z);
logic [15:0] x,y;
logic [15:0] c;
getmax max1 (x,y,c);
// Conv1
logic [15:0] filter [0:3*3*3-1];
logic [31:0] conv1biases [0:63];
logic [31:0] bias;
logic [15:0] conv1out [0:111*111-1];
string filename;
int outfile;
// Max Pool
logic [15:0] maxpoolout [0:55*55-1];
// Fire 1
logic [15:0] inpsqueeze [0:64*55*55-1];
logic [15:0] squeezeweight [0:55*55-1];
logic [15:0] sqbias;
logic [15:0] sqbiases [0:15];
logic [15:0] sqout [0:55*55-1];
// Simulation
initial begin
// $readmemh("inpf.txt", img);
// Conv 1 Layer
// $readmemh("sqnetparams/conv1/biases.txt", conv1biases);
// outfile = $fopen("./sqnetparams/conv1/output/conv1opall.txt","a");
// for (int i=1; i<65; i++) begin
//     filename = $sformatf("sqnetparams/conv1/weights/conv1wf%0d.txt",i);
//     $readmemh(filename,filter);
//     bias=conv1biases[i-1];
//     conv2d3x3();   
//     filename = $sformatf("sqnetparams/conv1/output/conv1op%0d.txt",i);         
//     $writememh(filename,conv1out);
//     for(int j=0; j<111*111; j++)
//         $fdisplay(outfile,"%h",conv1out[j]);
// end
// $fclose(outfile);

// Max Pool Layer
// outfile = $fopen("./sqnetparams/maxpool1/output/maxpoolopall.txt","a");
// for (int i=1; i<65; i++) begin
//     filename = $sformatf("sqnetparams/conv1/output/conv1op%0d.txt",i);         
//     $readmemh(filename,conv1out);
//     maxpool2d3x3();
//     filename = $sformatf("sqnetparams/maxpool1/output/maxpool1op%0d.txt",i);         
//     $writememh(filename,maxpoolout);
//     for(int j=0; j<55*55; j++)
//         $fdisplay(outfile,"%h",maxpoolout[j]);
// end
// $fclose(outfile);

// Fire 1 Squeeze 
outfile = $fopen("./sqnetparams/squeeze1/output/sq1outall.txt","a");
$readmemh("sqnetparams/squeeze1/biases.txt",sqbiases);
$readmemh("sqnetparams/maxpool1/output/maxpoolopall.txt",inpsqueeze);
for (int i=1; i<=16; i++) begin
    // load weights
    filename = $sformatf("sqnetparams/squeeze1/sq1wf%0d.txt",i);         
    $readmemh(filename,squeezeweight);
    // load input image
    filename = $sformatf("sqnetparams/maxpool1/output/maxpool1op%0d.txt",i);         
    $readmemh(filename,maxpoolout);
    // load bias
    sqbias = sqbiases[i-1];
    // Execute
    fire1_squeeze1x1();
    // save
    filename = $sformatf("sqnetparams/squeeze1/output/sq1op%0d.txt",i);         
    $writememh(filename,sqout);
    for(int j=0; j<55*55; j++)
        $fdisplay(outfile,"%h",sqout[j]);
end
$fclose(outfile);

end

task conv2d3x3;
logic [31:0] tmp;
for (int i=0;i < 111; i++) begin
    for (int j=0; j < 111; j++) begin
        tmp=bias;
        for (int k=0; k<3; k++) begin
            for (int l=0; l<3; l++) begin
                for (int m=0; m<3; m++) begin
                    a=img[k * 224 * 224 + (i * 2 + l - 0) * 224 + j * 2 + m - 0];
                    b=filter[9*k+3*l+m];
                    #10ns;
                    tmp = tmp + z;
                end
            end
        end
        conv1out[i*111+j] = {tmp[23:16],tmp[15:8]};
    end
end
endtask

task maxpool2d3x3;
reg [15:0] tmp;
reg [15:0] value;
//loop over output feature map

	for(int i = 0; i < 55; i++)//row
	begin
		for(int j = 0; j < 55; j++)//col
		begin
            tmp=0;
        	//find the max value in 3x3 region 
			//to be one element in the output feature map
			for(int k = 0; k < 3; k++)//row
			begin
				for(int l = 0; l < 3; l++)//col
				begin
					value = conv1out[(i * 2 + k) * 111  + j * 2 + l ];
                    x = value;
                    y = tmp;
                    #10ns;
                    tmp = c;
                end
            end
			//store the result to output feature map
            maxpoolout[i*55+j] = tmp;
        end
    end

endtask
task fire1_squeeze1x1;
reg [15:0] tmp1;
	//output_im += filter_index * input_size_x * input_size_y;//start_channel is for 1x1 feature map in fire layer

	//loop over output feature map
	//out
	for(int i = 0; i < 55; i++)
	begin
		for(int j = 0; j < 55; j++)
		begin
			tmp1 = sqbias;

			for(int k = 0; k < 64; k++)
			begin
				a = inpsqueeze[k * 55 * 55 + i * 55 + j];
                b = squeezeweight[k];
                #10ns;
                tmp1 = {z[23:16],z[15:8]} + tmp1;
            end
			//add relu after conv
			//*output_im = (tmp > 0.0) ? tmp : 0.0;
			//output_im++;
            sqout[i*55 + j] = tmp1;
        end
    end
endtask
endmodule

