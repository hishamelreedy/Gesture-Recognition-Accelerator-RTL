clear;clc
load conv1;
fullimage = imread('circle.jpg');
imshow(fullimage)
targetSize = [224 224];
window = centerCropWindow2d(size(fullimage),targetSize);
B1 = imcrop(fullimage,window);
imshow(B1)
stride=2;
x=B1;
in=double(x);
for imi= 1:224
    for imj=1:224
        for imk=1:3
            in(imi,imj,imk)=((in(imi,imj,imk)/255)-0.5)/0.5;
        end
    end
end

conv1out=zeros(111,111,64);
out=zeros(111,111);
for kerid=1:1
for ix=1:3
    for jx=1:3
        for kx=1:3
            kernel(ix,jx,kx)=conv1weight(kerid,kx,ix,jx);
        end
    end
end
%in=sfi(in,16,8);
%kernel=sfi(kernel,16,8);
for i=1:2:222
    for j=1:2:222
        %tmp=sfi(conv1bias(kerid),32,16);
        tmp=conv1bias(kerid);
        for k=1:3
            for l=1:3
                for m=1:3
                    tmp = tmp + in(i+l-1,j+m-1,k) * kernel(l,m,k);
                end
            end
        end
        if (tmp>0)
            out(i,j) = tmp;
        else
            out(i,j) = tmp;
        end
    end
end
out(stride:stride:end,:,:) = [];
out(:,stride:stride:end,:) = [];
conv1out(:,:,kerid)=out;
end
% end
figure();
%imshow(out);
%out(stride:stride:end,:,:) = [];
%out(:,stride:stride:end,:) = [];
conv1out = sfi(conv1out,16,8);
%save('conv1out.mat','conv1out');
conv1out(1,1,1)