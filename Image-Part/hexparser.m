clear;clc
FID = fopen('sqnetparams/maxpool1/output/maxpoolopall.txt');
form='%c%c%c%c'; % we have 7 columns, then use 7 %f
n = 55*55*64; % numbers of lines representing a text 
lines = 55*55*64;
n = 0;
out = textscan(FID, form,'headerlines', n);
fclose(FID);
out=cell2mat(out);

for i = 1:lines
    tmp = sfi(1,16,8);
    tmp.hex = out(i,:);
    data(i)=tmp;
end
data = data';