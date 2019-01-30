function [differentWaves] = identifySameWaves(this)

differentWavesCount = 1;
channelArray = this.propertyVector('channel');
triggerTimeArray = this.propertyVector('triggerTime');
cycle = 1;

tolerance = 3e-3*(2.5e6);

differentWaves = zeros(1,length(this.Waves));
allWavesVerified = 0;
waveIndex = 1;
T = 0;
while ~allWavesVerified
    if differentWaves(waveIndex) == 0
        wave = this.Waves(waveIndex);
        
        if cycle <= length(this.cycleDividers)
            if wave.file > this.cycleDividers(cycle)
                cycle = cycle+1;
            end
        end
        
        delta = (this.channelDelays{cycle}(channelArray) ...
            - this.channelDelays{cycle}(wave.channel));
        
        sameWavesIndexes = ...
            (((triggerTimeArray)*2.5e6 <= ((wave.triggerTime)*2.5e6 + delta + tolerance)) ...
            & ((triggerTimeArray)*2.5e6 >= ((wave.triggerTime)*2.5e6 + delta - tolerance))) ...
            & (channelArray ~= wave.channel);
        
        sameWavesIndexes(waveIndex) = differentWavesCount;
        differentWaves(sameWavesIndexes) = differentWavesCount;
        differentWavesCount = differentWavesCount+1;
        
        if waveIndex >= length(differentWaves)
            allWavesVerified = 1;
        end
        
        waveIndex = waveIndex+1;
    else
        waveIndex = waveIndex+1;
        if waveIndex > length(differentWaves)
            allWavesVerified = 1;
        end
    end
    
end


end