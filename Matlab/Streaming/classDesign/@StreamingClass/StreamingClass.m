classdef StreamingClass
    properties
        Waves = [];
        pdt
        hdt
        hlt
        countWaveform = 0;
    end
    methods
        function this = addWaveCount(this)
            this.countWaveform = this.countWaveform + 1;
        end
        function this = addWave(this, Wave)
                if ~isempty(this.Waves)
                    this.Waves(end+1) = Wave;
                else
                    this.Waves = Wave;
                end
                this = this.addWaveCount();
        end
        propertyArray = propertyVector(this, propertyString);
        this = identifyWaves(this, rawData, channels, fs, noiseLevel, ...
            fileNumber, lastIndex)
    end
end