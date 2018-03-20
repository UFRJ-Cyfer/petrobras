function [ normalizedData ] = normalizeData( inputData, dim )
%NORMALIZEDATA Z-Score normalization function
%   Removes the mean value (sets it to 0) and standard deviation (sets it
%   to 1)

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

