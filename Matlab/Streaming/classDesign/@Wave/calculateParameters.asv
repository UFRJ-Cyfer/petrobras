function [ wave ] = calculateParameters( wave )
%CALCULATEPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    rawData = wave.rawData;
    fs = wave.samplingFrequency;
    
    wave.maxAmplitude = max(rawData);
    wave.duration = length(rawData)/wave.samplingFrequency;
    wave.energy = sqrt(sum(rawData.^2));
    wave.rms = norm(double(rawData),2);
    deltaTime = wave.triggerTime - wave.startingTime;
    
    triggerIndex = ceil(deltaTime*fs);
    hdtIndex = ceil(1e-3*fs);
    wave.count = sum(diff(rawData(1:end-hdtIndex-1) > wave.threshold) == 1);
    
    [~, maxTime] = max(rawData);
    wave.riseTime = (maxTime - triggerIndex)/fs;
    
    
    
    
end

