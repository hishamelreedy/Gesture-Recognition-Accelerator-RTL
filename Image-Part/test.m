% clear; clc
load conv1
load in
load ink
sample=in(1:3,1:3,1);
samplek=kernel(:,:,1);
sampleout=samplek.*sample;
sampleoutbin=sfi(sampleout,32,16);
sampleouthex=sampleoutbin.hex;

a=sfi(1,16,8);
a.hex='001f';
b=a;
b.hex='ff46';
c=a*b;

sample=sfi(sample,16,8);
samplek=sfi(samplek,16,8);
sampleout=sample.*samplek
sampleout.hex
z=sum(sampleout(:))+sfi(conv1bias(kerid),32,16);
z=sfi(conv1bias(kerid),32,16)+sampleout(1);
z.hex