function [ streamingStructCleaned, structDT, tofdIndexes ] = removeTOFD( streamingStruct )
%REMOVETOFD Summary of this function goes here
%   Detailed explanation goes here



tofdDelay = 0.02;
tolerance = 10/100;
tofdGroupDelay = 1;
indexesStructFormatted = [];
streamingStructCleaned = streamingStruct;

for structIndex = 1:length(streamingStruct)
    if ~isempty(streamingStruct(structIndex).rawData)
    structDT = struct;
    channels = unique(streamingStruct(structIndex).channel);
    structDT(length(channels)).dt = [];
    indexesStructFormatted = [];
    
    for channel = channels
        structDT(channel).dt = ...
            diff(streamingStruct(structIndex).startingTime(streamingStruct(structIndex).channel == channel));
        
        structDT(channel).dt(structDT(channel).dt > tofdDelay*(1 - tolerance) & structDT(channel).dt < tofdDelay*(1 + tolerance)) = tofdDelay;
        structDT(channel).dt(structDT(channel).dt > tofdGroupDelay*(1 - tolerance) & structDT(channel).dt < tofdGroupDelay*(1 + tolerance)) = tofdGroupDelay;
        
        if length(structDT(channel).dt) > 5
            tofdIndexes(channel).removeIndexes = identifyTOFDBlocks( structDT(channel).dt );
            if ~isempty(tofdIndexes(channel).removeIndexes)
                locations = find(streamingStructCleaned(structIndex).channel == channel);
                indexesStructFormatted = [indexesStructFormatted locations(tofdIndexes(channel).removeIndexes)];
            end
        end
        
        
    end
    
    streamingStructCleaned(structIndex).channel(indexesStructFormatted) = [];
    streamingStructCleaned(structIndex).resolution(indexesStructFormatted) = [];
    streamingStructCleaned(structIndex).fileNumber(indexesStructFormatted) = [];
    streamingStructCleaned(structIndex).startingTime(indexesStructFormatted) = [];
    streamingStructCleaned(structIndex).rawData(:,indexesStructFormatted) = [];
    
    end
end
end

