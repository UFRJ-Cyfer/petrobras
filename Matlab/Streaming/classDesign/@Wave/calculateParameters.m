function [ wave ] = calculateParameters( wave, fs, streamingClass )
%CALCULATEPARAMETERS Method that calculates the AE wave parameters

%   It basically calculates all PAC AE parameters (check manual).

    rawData = wave.rawData;
    rawDataRectified = rawData;
    rawDataRectified(rawDataRectified < 0) = rawDataRectified(rawDataRectified < 0) * -1;
    hdtIndex = ceil(streamingClass.hdt*fs);
     rawDataDB = 20*log(double(rawDataRectified) * (10/(2^13*4)) / (10e-6)) - 40;

    [wave.maxAmplitude, peakIndex] = max(rawData);
%     peakIndex
    %Amp(db) = 20log(V/1u) - preAmp gain (however I did 1/mV because I
    %think [A * cv] = mV
    wave.maxAmplitudeDB = ...
         20*log(double(wave.maxAmplitude) * (10/(2^13*4)) / (10e-6)) - 80;
     
    wave.averageSignalLevel = mean(rawDataDB(1:end-hdtIndex-1));
     
    wave.duration = length(rawData)/fs - streamingClass.hdt;
    wave.energy = sum(rawData(1:end-hdtIndex-1).^2) / 1e4; %1e4 = 10kOhm
    wave.rms = norm(double(rawData(1:end-hdtIndex-1)),2);
    
    wave.count = sum(diff(rawData(1:end-hdtIndex-1) > wave.threshold) == 1);
    
    
    wave.countToPeak = sum(diff(rawData(1:peakIndex) > wave.threshold) == 1);
    
    wave.riseTime = double((peakIndex - wave.relativeTriggerIndex))/fs;
    
    wave.resolutionLevelCount = uint16(length(unique(rawData)));
    
    wave.averageFrequency = double(wave.count) / (double(wave.duration)*1e6);
    
    if (wave.duration - wave.riseTime) ~= 0
        wave.reverberationFrequency = (wave.count - wave.countToPeak)/ ...
                                      (double(wave.duration) -  double(wave.riseTime))/1e6;
    else
        wave.reverberationFrequency = 0; %%%%%%%%%%%%%%%%%%
    end
    
    if wave.riseTime ==0
        wave.initiationFrequency = 0;
    else
            wave.initiationFrequency = wave.countToPeak/(double(wave.riseTime)*1e6);

    end
    
    
    
end

