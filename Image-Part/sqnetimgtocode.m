clear;clc
% Fraction
Fractionlength=8;
Integerlength=8;
wordlength=Integerlength+Fractionlength;

load conv1;
fullimage = imread('circle.jpg');
imshow(fullimage)
targetSize = [224 224];
window = centerCropWindow2d(size(fullimage),targetSize);
B1 = imcrop(fullimage,window);
imshow(B1)
stride=2;
x=B1;
in1=double(x);
for imi= 1:224
    for imj=1:224
        for imk=1:3
            in1(imi,imj,imk)=((in1(imi,imj,imk)/255)-0.5)/0.5;
        end
    end
end
in1=pagetranspose(in1);
in=in1;
save('in.mat','in');
in1=in1(:);

fileID = fopen('inpf.txt','w');
d1=sfi(in1,wordlength,Fractionlength);
d=sfi(in1,wordlength,Fractionlength).hex;
for i=1:224*224*3
    fprintf(fileID,'%s\n',d(i,:));
end
% Conv1 Weights
for kerid=1:64
    kernel=zeros(3,3,3);
    for ix=1:3
        for jx=1:3
            for kx=1:3
                kernel(ix,jx,kx)=conv1weight(kerid,kx,ix,jx);
            end
        end
    end
    x=kernel;
    kernel=pagetranspose(kernel);
    kernel=kernel(:);
    fileID = fopen(strcat('temp/conv1wf',num2str(kerid),'.txt'),'w');
    d=sfi(kernel,wordlength,Fractionlength).hex;
    for i=1:size(kernel)
        fprintf(fileID,'%s\n',d(i,:));
    end
    fclose(fileID);
end
fileID = fopen('temp/biases.txt','w');
for i=1:64
    d=sfi(conv1bias(i),32,16).hex;
    fprintf(fileID,'%s\n',d);
end
fclose(fileID);

