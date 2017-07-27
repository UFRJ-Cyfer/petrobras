function [ filteredData ] = filterStreaming( rawData, fs, f )
%FILTERSTREAMING Summary of this function goes here
%   Detailed explanation goes here
digitalFilter = 0;


if ~isfloat(rawData)
   rawData = single(rawData); 
end

fnorm = f/fs;
if digitalFilter
    df = designfilt('lowpassfir','FilterOrder',5,'CutoffFrequency',fnorm);
    D = mean(grpdelay(df));
    D = floor(D);
    filteredData = filter(df,[rawData; zeros(D,size(rawData,2))]); % Append D zeros to the input data
    filteredData = filteredData(D+1:end,:);                  % Shift data to compensate for delay
else
    movAvgCount = 50;
    coeff = ones(1,movAvgCount);
    filteredData = filter(coeff,1,rawData);
end

end

