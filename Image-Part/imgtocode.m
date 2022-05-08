close all;
clear;clc
chips = imread('dog.jpg');
imshow(chips)
targetSize = [224 224];
win1 = centerCropWindow2d(size(chips),targetSize);
B1 = imcrop(chips,win1);
%imshow(B1)
B1_r =  B1(:,:,1)';
x=B1(:,:,1);
B1_r=int16(B1_r);
B1_g =  B1(:,:,2)';
B1_g=int16(B1_g);
B1_b =  B1(:,:,3)';
B1_b=int16(B1_b);
B1_r=B1_r(:);
B1_g=B1_g(:);
B1_b=B1_b(:);

fileID = fopen('input.txt','w');
d=dec2hex(B1_r);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

fileID = fopen('input1.txt','w');
d=dec2hex(B1_g);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

fileID = fopen('input2.txt','w');
d=dec2hex(B1_b);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

% Kernel to Code
kernel1=[-1,-2,-1;0,0,0;1,2,1];
kernel(:,:,1)=kernel1;
kernel(:,:,2)=kernel1;
kernel(:,:,3)=kernel1;
kernel=pagetranspose(kernel);
kernel=kernel(:);
kernel=int16(kernel);
fileID = fopen('conv1w.txt','w');
d=dec2hex(kernel,4);
for i=1:size(kernel)
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

% RGB To Code
fileID = fopen('inp.txt','w');
d=dec2hex(B1_r);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end

d=dec2hex(B1_g);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end

d=dec2hex(B1_b);
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

% Fraction
Fractionlength=4;
Integerlength=20;
wordlength=Integerlength+Fractionlength;

fileID = fopen('inpf.txt','w');
d=sfi(B1_r,wordlength,Fractionlength).hex;
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end

d=sfi(B1_g,wordlength,Fractionlength).hex;
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end

d=sfi(B1_b,wordlength,Fractionlength).hex;
for i=1:50176
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);

fileID = fopen('conv1wf.txt','w');
d=sfi(kernel,wordlength,Fractionlength).hex;
for i=1:size(kernel)
    fprintf(fileID,'%s\n',d(i,:));
end
fclose(fileID);
