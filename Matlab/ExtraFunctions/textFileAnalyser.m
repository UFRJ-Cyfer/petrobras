function [ textStruct ] = textFileAnalyser( filename, CP4 )
%TEXTFILEANALYSER Summary of this function goes here
%   Detailed explanation goes here

replaceinfile(',', '.', [filename])
temp = importdata([filename], ' ', 0);

Holder = temp.data;

[~, ~, ~, H, MN, S] = datevec(temp.textdata,'HH:MM:SS');

timeVallen = H*3600+MN*60+S;
timeVallen = timeVallen + Holder(:,1)/1000;

capturedWavesBool = Holder(:,end) == 0;

channels = Holder(:,2);

waveIndexes = Holder(:,9);
waveIndexes(1) = 0;
waveIndexes(waveIndexes==1) = 0;
waveIndexes(1) = 1;

timeVectorCaptured = timeVallen(capturedWavesBool);

textStruct.rawTimeVector = timeVallen;
textStruct.timeVectorCaptured = timeVectorCaptured;
textStruct.channels = channels;
textStruct.capturedWavesBool = capturedWavesBool;
textStruct.rawTimeVector = timeVallen;
textStruct.waveIndexes = waveIndexes;
end

