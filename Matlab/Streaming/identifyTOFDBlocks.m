function [ tofdIndexes ] = identifyTOFDBlocks( dtVector )
    tofdDelay = 0.02;
    tolerance = 10/100;
    tofdGroupDelay = 1;

    tofdDelayIndexes = find(dtVector~=tofdDelay);
    tofdIndexes = [];
    
    for k=1:length(tofdDelayIndexes)
        if dtVector(tofdDelayIndexes(k)) == 1
            tofdIndexes = [tofdIndexes (tofdDelayIndexes(k)-4):tofdDelayIndexes(k)];
        end
        
    end

end