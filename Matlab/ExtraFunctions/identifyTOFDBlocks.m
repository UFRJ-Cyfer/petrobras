function [ tofdIndexes ] = identifyTOFDBlocks( dtVector )

%IDENTIFYTOFDBLOCKS Identify the indexes that represent a TOFD signal

% dtVector - An array that hold the derivative (diff) of the arrive times
% from the identified waves. 
%
% Basically, if the delta time from the identified waves is somewhere along
% 20ms-+10%, followed by a 1 second difference (the groups of five delay)
% then those indexes get returned to be eliminated.

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