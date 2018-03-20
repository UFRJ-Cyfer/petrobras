function [ textStruct ] = textFileAnalyser( filename, CP4 )
%TEXTFILEANALYSER Translates the text file outputted by PAC or VALLEN tests
   
 
%   reads from both PAC and vallen text files (the one that outputs the
%   parameters) and translates the information to a specialized structure
%   for future use

% replaceinfile(',', '.', [filename])
temp = importdata([filename], ' ', 0);

Holder = temp.data;

[~, ~, ~, H, MN, S] = datevec(temp.textdata(:,3),'HH:MM:SS');

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

