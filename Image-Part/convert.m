imageWidth = 224;
imageHeight = 224;
numColor = 1;

i=imread('test.bmp');
fileID = fopen('test.txt','w');
for r = 1:imageHeight
    for c = 1:imageWidth
        for m = 1:numColor
            fwrite(fileID,dec2hex(i(r,c,m)));
            fprintf(fileID,'\n');
        end
    end
end
fclose(fileID);