function [ rawData ] = removeTOFD( rawData )
%REMOVETOFD Summary of this function goes here
%   Detailed explanation goes here
NUM_CHANNELS = 16;
FS = 2.5e6;
TOLERANCE = 10/100;

for ch=1:size(rawData,2)
    ch
    rawData(:,ch) = rawData(:,ch) - mean(rawData(:,ch));
    noiseLevel = 3*std(diff(single(rawData(:,ch))));
    thresholdSignalsPositions = (abs(diff(single(rawData(:,ch)))) > 2*noiseLevel);
    
    indexes = find(thresholdSignalsPositions);
    if ~isempty(indexes)
        
        diffIndexes = diff(indexes);
        diffIndexes (diffIndexes<10000) =0;
        startingLocation = find(diffIndexes ~=0);
        startingIndexes = [indexes(1); indexes(startingLocation+1); indexes(end)];
        
        allWavesLocation = rawData(:,ch) > noiseLevel;
        
        
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
    zeroSlotBackward = 1000;
    zeroSlotForward = 0;
    
    for k=1:length(tofdIndexes)
        if k == length(tofdIndexes)
            aux = find((diff(extractedChannel(tofdIndexes(k):end))) >= noiseLevel);
        else
            aux = find((diff(extractedChannel(tofdIndexes(k):tofdIndexes(k+1)))) >= noiseLevel);
        end
        nextWaveIndexes = find(diff(aux) > 1000);
        
        if ~isempty(nextWaveIndexes)
            aux = aux(1:nextWaveIndexes-1);
        end
        
        if tofdIndexes(k) < (zeroSlotBackward+1)
            tofdIndexes(k) = zeroSlotBackward+1;
        end
        
        if tofdIndexes(k)+aux(end)+zeroSlotForward > 16777216
            aux(end) = 16777216 - zeroSlotBackward- firstFive(k);
        end
        slots = [slots tofdIndexes(k)-zeroSlotBackward:(tofdIndexes(k)+aux(end)+zeroSlotForward)];
    end
    rawData(slots,ch) = 0;
    end
end

end

