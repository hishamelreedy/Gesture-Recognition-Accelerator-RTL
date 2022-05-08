function z=conv1(a,b,stride)	
pad=0;
s=size(a);
input_size=s(1);
s=size(b);
kernel_size = s(1);
output_size=floor((((input_size - kernel_size + 2*pad)/stride) + 1))
input_channels = 3;
%loop over output feature map
z1=zeros(output_size,output_size);
for i = 1:output_size
    for j = 1:output_size
        tmp=0;
        %compute dot product of 2 input_channels x 3 x 3 matrix
        for k=1:input_channels
            for l = 1:3
                h = i * stride + l - pad;
                for m=1:3
                    w = j * stride + m - pad;
                    %if((h >= 1) && (h <= input_size) && (w >= 1) && (w <= input_size))                     
                        tmp = tmp + a(i*stride,j*stride,k)* b(l,m,k);
                    %end
                end
            end
        end
        z1(i,j) =  tmp;
    end
end
z=z1;
end