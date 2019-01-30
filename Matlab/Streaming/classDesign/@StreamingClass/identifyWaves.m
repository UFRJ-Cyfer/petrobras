function [obj, lastIndex] = identifyWaves(obj, rawData, channels, fs, noiseLevel,fileNumber, lastIndex, backupPath, cycle)
%Identifies all acoustic emission waves from within a streaming file. This function follows the guidelines contained on the PAC Manual describing how the AE capture is done. It uses only two (HDT and HLT) of the three timing parameters. The threshold is a multiplied noiseLevel (by a euristically defined number).
%
%   :param channels: Array containing all channels to investigate.
%   :type channels: double array
%
%   :param rawData: The raw collected wave data.
%   :type rawData: int16 Array
%
%   :param fs: Sampling Frequency
%   :type fs: double
%
%   :param noiseLevel: An array with the estimated noise level per channel.
%   :type noiseLevel: double Array
%
%   :param fileNumber: Which file to investigate.
%   :type fileNumber: double
%
%   :param backupPath: Absolute path to the local .mat files.
%   :type backupPath: string
%
%   :param cycle: Tells which cycle the file is located at.
%   :type cycle: double
%
%   :returns: A StreamingClass object with the captured waves stored.
%   :returns: The indexes where the last captured waves ended (per channel).

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
lastIndexLocal = ones(1,16)*ceil(HLT*fs)*-1;

for channel = channels
    
        thr = 5*noiseLevel(channel);
%     thr = 3*noiseLevel(channel);
    thresholdBool = rawData(:,channel) >= thr;
    %    thresholdBool(1:ceil(backTime/ts)) = 0;
    
    
    
    indexes = find(thresholdBool);
    splitFile = 0;
    %     indexes = indexes(diff([1;indexes]) >= 5000);
    if numel(indexes) > 0
        
        indexToCapture = indexes(1);
        findable = 1;
        
        
        dsig = diff([1 thresholdBool' 1]);
        
        while findable
            if numel(indexes) == 0
                break;
            end
            
            beginIndex = indexToCapture - backTime/ts;
            
            if beginIndex >= lastIndex(channel) + ceil(HLT*fs)
                
                endIndex = find(dsig > 0)-1;
                startIndexHDTBlock = find(dsig < 0);
                duration = endIndex-startIndexHDTBlock+1;
                stringIndex = (duration >= HDT/ts);
                startIndexHDTBlock = startIndexHDTBlock(stringIndex);
                %
                if (isempty(startIndexHDTBlock) || startIndexHDTBlock(end) < indexToCapture)
                    
                    fprintf(['Long wave detected on the end of file %i,' ...
                        ' channel %i, checking next one\n'], fileNumber, channel)
                    
                    try
                        folderPath = obj.folderTDMS{cycle};
                    catch E
                        folderPath = obj.folderTDMS{1};
                    end
                    
                    rawDataAfter = readStreamingFile(...
                        [obj.fileTemplate{cycle} num2str(fileNumber+1,'%03d') '.tdms'], ...
                        folderPath, backupPath);
                    
                    thresholdBoolAfter = rawDataAfter(:,channel) >= thr;
                    
                    if ~isempty(thresholdBoolAfter)
                        
                        dsigAfter = diff([1 thresholdBoolAfter' 1]);
                        startIndexHDTBlockAfter = find(dsigAfter < 0);
                        endIndexAfter = find(dsigAfter > 0)-1;
                        
                        durationAfter = endIndexAfter-startIndexHDTBlockAfter+1;
                        stringIndexAfter = (durationAfter >= HDT/ts);
                        startIndexHDTBlockAfter = startIndexHDTBlockAfter(stringIndexAfter);
                        
                        if ~isempty(startIndexHDTBlockAfter)
                            lastIndex(channel) =  startIndexHDTBlockAfter(1);
                        else
                            lastIndex(channel) = ceil(HDT/fs);
                        end
                        capturedWave = [rawData(beginIndex:end ,channel) ;...
                            rawDataAfter(1:lastIndex(channel), channel)];
                        splitFile = 1;
                        obj.DEBUG_lastIndexArray(end+1,channel) = lastIndex(channel);
                    else
                        capturedWave = rawData(beginIndex:end ,channel);
                        lastIndex(channel) = ceil(HLT*fs)*-1;
%                         lastIndexLocal(channel) = 2^24;
                    end
                    
                    findable = 0;
                else
                    [HDTRStart] = min(startIndexHDTBlock(startIndexHDTBlock > indexToCapture) - indexToCapture);
                    endIndex = indexToCapture + HDTRStart;
                    lastIndexLocal(channel) = endIndex + ceil(HDT*fs);
                    capturedWave = rawData(beginIndex:lastIndexLocal(channel),channel);
                   
                end
                
                if length(unique(capturedWave)) >= 128
                    
                    wave = Wave(capturedWave, ...
                        channel, thr, offsetTime + time(indexToCapture),...
                        indexToCapture, indexToCapture-beginIndex);
                    
                    obj.DEBUG_lastIndexArray(end+1,channel) = lastIndex(channel);
                    
                    wave = wave.calculateParameters(fs, obj);
                    wave.file = fileNumber;
                    
                    if splitFile
                        wave.splitFile = true;
                        wave.splitIndex = uint32(length(capturedWave) - lastIndexLocal(channel) + 1);
                    end
                    %        startingTime(waveCount) = time(beginIndex);
                    %        triggerTime(waveCount) = time(indexToCapture);
                    %                     plot(wave.rawData)
                    obj = obj.addWave(wave);
                end
            end
            
            [auxIndex] = find(indexes-(lastIndexLocal(channel) + ...
                ceil((HLT+backTime)/ts)) > 0);
            
            [auxIndex_] = find(indexes-(lastIndex(channel) + ...
                ceil((HLT+backTime)/ts)) > 0);
            
            if length(auxIndex_) <= length(auxIndex)
                indexes = indexes(auxIndex_);
            else
               indexes = indexes(auxIndex); 
            end
            %only one wave captured
            if isempty(indexes)
                break;
            end
            
            indexToCapture = indexes((1));
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