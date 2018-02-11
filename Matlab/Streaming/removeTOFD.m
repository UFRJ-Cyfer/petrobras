function [ rawData, noiseLevel, slots] = removeTOFD( rawData, channels )
%REMOVETOFD Summary of this function goes here
%   Detailed explanation goes here
NUM_CHANNELS = 16;
FS = 2.5e6;
TOLERANCE = 10/100;
noiseLevel = zeros(1,16);
slots = [];

for ch=1:16
    noiseLevel(ch) = 3*std(diff(single(rawData(:,ch) - mean(rawData(:,ch)))));
end

for ch=channels
    
    rawData(:,ch) = rawData(:,ch) - mean(rawData(:,ch));
%     noiseLevel = 3*std(diff(single(rawData(:,ch))));
    thresholdSignalsPositions = (abs(diff(single(rawData(:,ch)))) > 1.8*noiseLevel(ch));
    
    indexes = find(thresholdSignalsPositions);
    if ~isempty(indexes)
        
        diffIndexes = diff(indexes);
        diffIndexes (diffIndexes<10000) =0;
        startingLocation = find(diffIndexes ~=0);
        startingIndexes = [indexes(1); indexes(startingLocation+1); indexes(end)];
        
        allWavesLocation = rawData(:,ch) > noiseLevel(ch);
        
        
        diffStartingIndexes = diff(startingIndexes);
        
        diffStartingIndexes(diffStartingIndexes < 0.02*FS*(1+TOLERANCE) & ...
            diffStartingIndexes > 0.02*FS*(1-TOLERANCE)) = 0.02*FS;
        
        diffStartingIndexes(diffStartingIndexes < FS*(1+TOLERANCE) & ...
            diffStartingIndexes > FS*(1-TOLERANCE)) = FS;
        
        tofdIndexes = [];
        for l=1:length(diffStartingIndexes)
            if diffStartingIndexes(l) == 0.02*FS
                tofdIndexes = [tofdIndexes l l+1];
%             if l~=length(diffStartingIndexes)
%                 aux = diffStartingIndexes(l) + diffStartingIndexes(l+1)
%             end  
        end
    end
    tofdIndexes = unique(tofdIndexes);
    tofdIndexes = startingIndexes(tofdIndexes);
    extractedChannel = rawData(:,ch);
    
    slots = [];
    zeroSlotBackward = 25000;
    zeroSlotForward = 25000;
    
    for k=1:length(tofdIndexes)
        if k == length(tofdIndexes)
            aux = find((diff(extractedChannel(tofdIndexes(k):end))) >= 1.2*noiseLevel(ch));
        else
            aux = find((diff(extractedChannel(tofdIndexes(k):tofdIndexes(k+1)))) >= 1.2*noiseLevel(ch));
        end
        nextWaveIndexes = find(diff(aux) > 1000);
        
        if ~isempty(nextWaveIndexes)
            aux = aux(1:nextWaveIndexes(1));
        end
        
        if tofdIndexes(k) < (zeroSlotBackward+1)
            tofdIndexes(k) = zeroSlotBackward+1;
        end
        
%         if isempty(aux)
%             
%         end
        
        if tofdIndexes(k)+aux(end)+zeroSlotForward > 16777216
            aux(end) = 16777216 - zeroSlotBackward - tofdIndexes(k);
        end
        slots = [slots tofdIndexes(k)-zeroSlotBackward:(tofdIndexes(k)+aux(end)+zeroSlotForward)];
    end
    rawData(slots,ch) = NaN;
    end
end
% rawDataOutput = rawData;
end

