classdef StreamingClass
    % STREAMINGCLASS A class that contains the acoustic emission test data
    
    % This struct basically is a holder of Waves. It contains all waves
    % extracted throughout the acoustic emission test.
    
    % PDT, HDT, HLT are the timing parameters (check PAC Manual)
    properties
        Waves = [];
        hdt = 1000e-6;
        hlt = 1000e-6;
        pdt = 800e-6;
        countWaveform = 0;
        spIndexes = [];
        peIndexes = [];
        piIndexes = [];
        noiseLevelMatrix = [];
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
        [this, lastIndex] = identifyWaves(this, rawData, channels, fs, noiseLevel, ...
            fileNumber, lastIndex, backupPath)
        function propertyMatrix = outputAllProperties(this)
            fields = this.Waves(1,1).fields;
            propertyMatrix = zeros(length(fields)-1, this.countWaveform);
            
            for k=2:length(fields)
                propertyMatrix(k-1,:) = this.propertyVector(fields{k});
            end
        end
    end
end