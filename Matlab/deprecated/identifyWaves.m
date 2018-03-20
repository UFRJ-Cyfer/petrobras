function [waves, startingTime, triggerTime] = identifyWaves(rawData, channels, fs, noiseLevel)

%IDENTIFYWAVES A function that returns acoustic emission waves of the same size


% NOW THIS IS DEPRECATED, AE SIGNALS ARE INHERENTLY OF DIFFERENT DURATIONS, 
% THIS WAS A FIRST ATTEMPT AT READING THE STREAMING FILES

ts = 1/fs;
PDT = 200e-6;
HDT = 5*1000e-6;
HLT = 10*1000e-6;
backTime = 2*1000e-6;
waves = zeros(round((backTime+HLT+HDT)/ts)+1, 1000);
startingTime = zeros(1,1000) - 1;
triggerTime = startingTime;
waveCount = 1;
time = ts*(0:size(rawData,1)-1);
findable = 1;

for channel = channels
    
%     rawData(:,channel) = rawData(:,channel) - mean(rawData(:,channel));
    
   thresholdBool = rawData(:,channel) >= 5*noiseLevel(channel);
   thresholdBool(1:ceil(backTime/ts)) = 0;
   
   indexes = find(thresholdBool);
   if numel(indexes) > 0
   
   indexToCapture = indexes(1);
   
   while findable
       if numel(indexes) == 0
          break; 
       end
       
       beginIndex = indexToCapture - backTime/ts;
       endIndex = indexToCapture + (HDT + HLT)/ts-1;
       
       if endIndex > size(rawData,1)
           endIndex = size(rawData,1); 
       end
       
       wave = [channel; rawData(beginIndex:endIndex,channel)];
       
 
       startingTime(waveCount) = time(beginIndex);
       triggerTime(waveCount) = time(indexToCapture);
       waves(1:size(wave,1),waveCount) = wave;
       waveCount = waveCount+1;
       
       if waveCount == 1001
          return; 
       end
       
       [auxIndex] = find(indexes-endIndex > 0);
       
       %only one wave captured
       if isempty(auxIndex)
           break;
       end
       
       indexToCapture = indexes(auxIndex(1));
       
       findable = (indexToCapture < (indexes(end) - ceil((HDT+HLT)/ts)));
   end
   end
end

wavesAux = (waves(:,waves(1,:)~=0));
startingTimeAux = startingTime(startingTime~=-1);
triggerTimeAux = triggerTime(triggerTime~=-1);
triggerTime = triggerTimeAux;
startingTime = startingTimeAux;
waves = int16(wavesAux);



end