function [ filteredData ] = filterStreaming( rawData, fs, f, fileNumber)
%FILTERSTREAMING Summary of this function goes here
%   Detailed explanation goes here
digitalFilter = 1;


if ~isfloat(rawData)
   rawData = single(rawData); 
end

fnorm = f/fs;
if digitalFilter
    df = designfilt('lowpassfir','FilterOrder',50,'CutoffFrequency',fnorm);
    D = mean(grpdelay(df));
    D = floor(D);
    filteredData = filter(df,[rawData; zeros(D,size(rawData,2))]); % Append D zeros to the input data
    filteredData = filteredData(D+1:end,:);                  % Shift data to compensate for delay
else
    movAvgCount = 50;
    coeff = ones(1,movAvgCount);
    filteredData = filter(coeff,1,rawData);
end
timeVector = 0:1:size(filteredData,1)-1;
timeVector = (timeVector + (fileNumber - 1) * 2^24)/fs;
timeVector = timeVector';


filteredData = filteredData - repmat(mean(filteredData,1), size(filteredData,1),1);
filteredData = [timeVector filteredData];

filteredData = filteredData(51:end,:);
end

