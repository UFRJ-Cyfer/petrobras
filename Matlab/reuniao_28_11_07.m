time = 2^24/2.5e6

indexes = 1:1:size(numBitsFileChannel,1);

%pre cleaning
spMatrix = numBitsFileChannel(1:560,:);
peMatrix = numBitsFileChannel(561:1326,:);
piMatrix = numBitsFileChannel(1327:end,:);

figure

for ch=1:16
    subplot(4,4,ch)
    index = 1;
    for bits = unique(spMatrix(:,ch))'
        bitCount(index) = sum(spMatrix(:,ch) == bits);
        bitAxis(index) = bits;
                index = index+1;

    end
    bitCountSP = bitCount;
    bitAxisSP = bitAxis;
    index = 1;
    clear bitCount bitAxis
    
    for bits = unique(peMatrix(:,ch))'
        bitCount(index) = sum(peMatrix(:,ch) == bits);
        bitAxis(index) = bits;
        index = index+1;
    end
    bitCountPE = bitCount;
    bitAxisPE = bitAxis;
    index = 1;
        clear bitCount bitAxis

    for bits = unique(piMatrix(:,ch))'
        bitCount(index) = sum(piMatrix(:,ch) == bits);
        bitAxis(index) = bits;
                index = index+1;

    end
    bitCountPI = bitCount;
    bitAxisPI = bitAxis;
    bitAxisFull = [0:14];
    bitCountMatrix = zeros(15,3);
    bitCountMatrix(bitAxisSP+1,1) = bitCountSP; 
bitCountMatrix(bitAxisPE+1,2) = bitCountPE; 
bitCountMatrix(bitAxisPI+1,3) = bitCountPI;
bitCountMatrix(1:4,:) = [];
bar(4:14,bitCountMatrix)
legend('SP','PE','PI')
title(['Canal ' num2str(ch)])
end




figure
for k=1:300
   plot(streamingStructCleaned(3).rawData) 
end