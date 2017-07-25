function [ normalizedData ] = normalizeData( inputData, dim )
%NORMALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
    normalizedData = inputData;
    
    if dim == 1
        inputData = inputData';
        normalizedData = normalizedData';
    end
    
    for k=1:size(inputData,2)
       normalizedData(:,k) = (normalizedData(:,k) - mean(normalizedData(:,k)))/std(normalizedData(:,k));
    end
    
    if dim == 1
        normalizedData = normalizedData';
    end

end

