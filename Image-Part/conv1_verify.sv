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
reg [15:0] maxpoolout [0:55*55-1];
// Simulation
initial begin
$readmemh("inpf.txt", img);
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
outfile = $fopen("./sqnetparams/maxpool1/output/maxpoolopall.txt","a");
for (int i=1; i<65; i++) begin
    filename = $sformatf("sqnetparams/conv1/output/conv1op%0d.txt",i);         
    $readmemh(filename,conv1out);
    maxpool2d3x3();
    filename = $sformatf("sqnetparams/maxpool1/output/maxpool1op%0d.txt",i);         
    $writememh(filename,maxpoolout);
    for(int j=0; j<55*55; j++)
        $fdisplay(outfile,"%h",maxpoolout[j]);
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
endmodule

