clear;clc
fullimage = imread('dog.jpg');
imshow(fullimage)
targetSize = [224 224];
window = centerCropWindow2d(size(fullimage),targetSize);
B1 = imcrop(fullimage,window);
imshow(B1)

x=B1;
in=double(x);
kernel = [1,2,1;0,0,0;-1,-2,-1];
kernel2 = [-1,-2,-1;0,0,0;1,2,1];
out = zeros(222,222);
tmp=0;
for i=1:222
    for j=1:222
        tmp=0;
        for k=1:3
            for l=1:3
                for m=1:3
                    tmp = tmp + in(i+l-1,j+m-1,k) * kernel2(l,m);
                end
            end
        end
        out(i,j) = tmp;
    end
end
figure();
imshow(out);
im1=imread('blurred_test224.bmp');

B1_r =  B1(:,:,1);
B1_g =  B1(:,:,2);
B1_b =  B1(:,:,3);
outch1=conv2(B1_r,kernel,'valid');
outch2=conv2(B1_g,kernel,'valid');
outch3=conv2(B1_b,kernel,'valid');
out2 = outch1+outch2+outch3;
out3 = outch1+outch2;

