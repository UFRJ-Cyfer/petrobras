function [obj, lastIndex] = identifyWaves(obj, rawData, channels, fs, noiseLevel,...
    fileNumber, lastIndex)

ts = 1/fs;
PDT = obj.pdt;
HDT = obj.hdt;
HLT = obj.hlt;
backTime = 2*1000e-6;

startingTime = zeros(1,1000) - 1;
triggerTime = startingTime;
waveCount = 1;
time = ts*(0:size(rawData,1)-1);
findable = 1;

fileTime = 2^24/(2.5e6);
offsetTime = fileTime*(fileNumber-1);

for channel = channels
    
    thr = 5*noiseLevel(channel);
    thresholdBool = rawData(:,channel) >= thr;
    %    thresholdBool(1:ceil(backTime/ts)) = 0;
    
    if ~isempty(find(thresholdBool(1:ceil(backTime/ts)), 1))
        rawDataBefore = readStreamingFile(fileNumber-1); %%%%%%%%%%%%%%%%%%%
    end
  
    indexes = find(thresholdBool);
    if numel(indexes) > 0
        
        indexToCapture = indexes(1);
        findable = 1;
        
        while findable
            if numel(indexes) == 0
                break;
            end
            
            beginIndex = indexToCapture - backTime/ts;
            
            if beginIndex >= lastIndex(channel) + ceil(HLT*fs)
                
                dsig = diff([1 thresholdBool' 1]);
                startIndexHDTBlock = find(dsig < 0);
                endIndex = find(dsig > 0)-1;
                duration = endIndex-startIndexHDTBlock+1;
                
                stringIndex = (duration >= HDT/ts);
                startIndexHDTBlock = startIndexHDTBlock(stringIndex);
                
                if (startIndexHDTBlock(end) < beginIndex) 
                    rawDataAfter = readStreamingFile(fileNumber+1); %%%%%%%%%%%%%%%%%%%
                    
                    thresholdBoolAfter = rawDataAfter(:,channel) >= thr;
                    dsigAfter = diff([1 thresholdBoolAfter' 1]);
                    startIndexHDTBlockAfter = find(dsigAfter < 0);
                    lastIndex(channel) = indexToCapture + startIndexHDTBlockAfter(1);
                    
                    capturedWave = [rawData(beginIndex:end ,channel) ;...
                        rawDataAfter(1:lastIndex(channel), channel)];
                    findable = 0;
                    
                else
                    [HDTRStart] = min(startIndexHDTBlock(startIndexHDTBlock > indexToCapture) - indexToCapture);
                    endIndex = indexToCapture + HDTRStart;
                    lastIndex(channel) = endIndex + ceil(HDT*fs);
                    capturedWave = rawData(beginIndex:lastIndex(channel),channel);
                    
                end
                
                
                wave = Wave(capturedWave, ...
                    channel, thr, offsetTime + time(indexToCapture),...
                    offsetTime + time(beginIndex), indexToCapture, ...
                    beginIndex);
                
                wave.samplingFrequency = fs;
                wave = wave.calculateParameters();
                
                %        startingTime(waveCount) = time(beginIndex);
                %        triggerTime(waveCount) = time(indexToCapture);
                
                obj = obj.addWave(wave);
            end
            
            %
            %        waves(1:size(wave,1),waveCount) = wave;
            %        waveCount = waveCount+1;
            %
            %        if waveCount == 1001
            %           return;
            %        end
            
            [auxIndex] = find(indexes-(lastIndex(channel) + ceil(HLT/ts)) > 0);
            
            %only one wave captured
            if isempty(auxIndex)
                break;
            end
            
            indexToCapture = indexes(auxIndex(1));
        end
    end
end
% 
% wavesAux = (waves(:,waves(1,:)~=0));
% startingTimeAux = startingTime(startingTime~=-1);
% triggerTimeAux = triggerTime(triggerTime~=-1);
% triggerTime = triggerTimeAux;
% startingTime = startingTimeAux;
% waves = int16(wavesAux);


end