close all;
clear;clc
chips = imread('dog.jpg');
imshow(chips)
targetSize = [224 224];
win1 = centerCropWindow2d(size(chips),targetSize);
B1 = imcrop(chips,win1);
imshow(B1)
B1_r =  B1(:,:,1);
B1_g =  B1(:,:,2);
B1_b =  B1(:,:,3);

imwrite(B1_r,'dog_ch1.bmp','bmp');
imwrite(B1_g,'dog_ch2.bmp','bmp');
imwrite(B1_b,'dog_ch3.bmp','bmp');
kernel=-1;
out=conv2(B1_r,kernel,'valid')+conv2(B1_g,kernel,'valid')+conv2(B1_b,kernel,'valid');