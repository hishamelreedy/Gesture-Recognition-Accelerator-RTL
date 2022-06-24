clear;clc
load maxpoolout;
load test.mat;
for filter = 1:16
    for imrow = 1:55
        for imcolumn = 1:55
            tmp=squeeze1bias(filter);
            for imchannel = 1:64
                tmp= tmp+ maxpoolout(imrow,imcolumn,imchannel)*squeeze1weights(filter,imchannel);
            end
            if tmp > 0
                sq1out(imrow,imcolumn,filter) = tmp;
            end
        end
    end
end
tot = sq1out(:,:,1);