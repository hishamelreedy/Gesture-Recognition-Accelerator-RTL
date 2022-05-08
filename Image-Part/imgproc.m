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
kernel=[1,2,1;0,0,0;-1,-2,-1];
%kernel=[1,0,-1;2,0,-2;1,0,-1];
kernel2=zeros(3,3,3);
kernel2(:,:,1)=kernel;
kernel2(:,:,2)=kernel;
kernel2(:,:,3)=kernel;

out=conv2(B1_r,kernel,'valid')+conv2(B1_g,kernel,'valid')+conv2(B1_b,kernel,'valid');

im1=imread('blurred_test224.bmp');

% Check Output
%clc; clear all ;
fid = fopen('output2.txt') ;  % open the text file
S = textscan(fid,'%s');   % text scan the data
fclose(fid) ;      % close the file
S = S{1} ;
N = cellfun(@(x)str2double(x), S);  % convert the cell array to double 
% Remove NaN's which were strings earlier
%N(isnan(N))=[];
%N=N(1:49284);
%out=out(:);
%test=sum(N-out);
N=reshape(N',[222,222]);
N=N';
% N=flip(N,1);
test=out-N;
test=test(:);
test=sum(test);