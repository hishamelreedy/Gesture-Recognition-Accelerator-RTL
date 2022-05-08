clear;clc
load conv1out
in = double(conv1out);
out = zeros(55,55);
tmp=0;
for i=1:2:110
    for j=1:2:110
        for k=1:64
            tmp=0;
            for l=1:3
                for m=1:3
                    if in(i+l-1,j+m-1,k) > tmp
                        tmp = in(i+l-1,j+m-1,k);
                    end
                end
            end
            out(i,j,k) = tmp;
        end
    end
end
out(2:2:end,:,:)=[];
out(:,2:2:end,:)=[];
maxpool = out;
maxpool = sfi(maxpool,16,8);
x=maxpool(:,:,1);
y=x.hex;
a = conv1out(:,:,1);
b = a.hex;
