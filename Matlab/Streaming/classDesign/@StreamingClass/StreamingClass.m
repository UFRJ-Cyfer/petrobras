classdef StreamingClass
    properties
        Waves = [];
        hdt = 1000e-6;
        hlt = 1000e-6;
        pdt = 800e-6;
        countWaveform = 0;
        description = 'CP3'
        folderTDMS = 'N:\CP3\Ciclo1'
        folderMatlabCopy = 'J:\BACKUPJ\ProjetoPetrobras'
        fileTemplate = 'IDR2_ensaio_03#'
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
        [this lastIndex] = identifyWaves(this, rawData, channels, fs, noiseLevel, ...
            fileNumber, lastIndex)
    end
end