function [ wave ] = calculateParameters( wave, fs, streamingClass )
%CALCULATEPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    rawData = wave.rawData;
    
    wave.maxAmplitude = max(rawData);
    wave.duration = length(rawData)/fs;
    wave.energy = sqrt(sum(rawData.^2));
    wave.rms = norm(double(rawData),2);
    
    
    hdtIndex = ceil(streamingClass.hdt*fs);
    wave.count = sum(diff(rawData(1:end-hdtIndex-1) > wave.threshold) == 1);
    
    [~, maxTime] = max(rawData);
    wave.riseTime = (maxTime - wave.relativeTriggerIndex)/fs;
    
    wave.resolutionLevelCount = uint16(length(unique(rawData)));
    
end

