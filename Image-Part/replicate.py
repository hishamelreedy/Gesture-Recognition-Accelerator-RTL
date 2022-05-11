texts=[]
for i in range(1,65):
    text = "conv2d3x3 #(.weightfile(\"sqnetparams/conv1/weights/conv1wf{}.txt\")) PE{} (\n\
        .clk(clk),\n\
        .rst(rst),\n\
        .imgdata1(imgdata1),\n\
        .imgdata2(imgdata2),\n\
        .imgdata3(imgdata3),\n\
        .imgdata4(imgdata4),\n\
        .imgdata5(imgdata5),\n\
        .imgdata6(imgdata6),\n\
        .imgdata7(imgdata7),\n\
        .imgdata8(imgdata8),\n\
        .imgdata9(imgdata9),\n\
        .output_im(output_im[{}]),\n\
        .bias(biases[{}]),\n\
        .i_data_valid(i_data_valid),\n\
        .currentRdChBuffer(currentRdChBuffer),\n\
        .o_convolved_data_valid(convolved_data_valid[{}])\n\
    );\n".format(i,i,i-1,i-1,i-1)
    texts.append(text)

textfile = open("conv1pes.txt", "w")
for element in texts:
    textfile.write(element + "\n")
textfile.close()


texts=[]
for i in range(1,257):
    text = "bank{}[i] <= 16'd0;".format(i)
    texts.append(text)

textfile = open("rep1.txt", "w")
for element in texts:
    textfile.write(element + "\n")
textfile.close()

texts=[]
for i in range(1,257):
    text = "bank{}[address] <= datainmem[{}];".format(i,i-1)
    texts.append(text)

textfile = open("rep1.txt", "w")
for element in texts:
    textfile.write(element + "\n")
textfile.close()

texts=[]
for i in range(1,257):
    text = "    dataoutmem[{}] <= bank{}[address2];".format(i-1,i)
    texts.append(text)

textfile = open("rep1.txt", "w")
for element in texts:
    textfile.write(element + "\n")
textfile.close()


texts=[]
for i in range(1,257):
    text = "reg [15:0] bank{} [0:111*111-1];".format(i)
    texts.append(text)

textfile = open("rep.txt", "w")
for element in texts:
    textfile.write(element + "\n")
textfile.close()