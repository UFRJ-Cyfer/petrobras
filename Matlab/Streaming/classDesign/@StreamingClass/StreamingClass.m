classdef StreamingClass
    % STREAMINGCLASS A class that contains the acoustic emission test data
    
    % This struct basically is a holder of Waves. It contains all waves
    % extracted throughout the acoustic emission test.
    
    % PDT, HDT, HLT are the timing parameters (check PAC Manual)
    properties
        Waves = [];
        StreamingModel = StreamingModel();
        hdt = 1000e-6;
        hlt = 1000e-6;
        pdt = 800e-6;
        countWaveform = 0;
        
        spIndexes = [];
        peIndexes = [];
        piIndexes = [];
        timePE = []; %starting time for PE class
        timePI = []; %starting time for PI class
        
        cycleDividers = [];
        adjusted = 0;
        
        noiseLevelMatrix = [];
        fields = {'rawData';'channel';'riseTime';'count';'energy';'duration';'rms';'maxAmplitudeDB';'resolutionLevelCount';'averageSignalLevel';'countToPeak';'averageFrequency';'reverberationFrequency';'initiationFrequency';'maxAmplitude';'threshold';'meanAmplitude';'absoluteTriggerIndex';'triggerTime';'relativeTriggerIndex';'splitFile';'splitIndex';'file'}
        
        description = [];
        folderTDMS = [];
        folderMatlabCopy = [];
        fileTemplate = [];
        
        frequencyDivisions = struct('power',[],'normalizedPower',[],'phase',[]);
        indexesChosenFrequencies = struct('power',[],'normalizedPower',[],'phase',[]);
        
        power = [];
        normalizedPower = [];
        phase = [];
        frequencyArray = [];
        freqSlots = [];
        
    end
    methods
        
        
        function obj = StreamingClass(CPString)
            
            switch CPString
                case 'CP2'
                    obj.timePE = 3000;
                    obj.timePI = 9500;
                    obj.description = 'CP2';
                    obj.folderTDMS = 'L:\EnsaioIDR02-2\SegundoTuboStreaming';
                    obj.folderMatlabCopy = 'G:\CP2RAWCOPY';
                    obj.fileTemplate = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#'};
                case 'CP3'
                    obj.timePE = 3000;
                    obj.timePI = 9000;
                    obj.description = 'CP3';
                    obj.folderTDMS = 'N:\CP3\Ciclo1';
                    obj.folderMatlabCopy = 'J:\BACKUPJ\ProjetoPetrobras';
                    obj.fileTemplate = 'IDR2_ensaio_03#';
                case 'CP4'
                    obj.timePE = 3000;
                    obj.timePI = 20000;
                    obj.description = 'CP4';
                    obj.folderTDMS = 'O:\CP4-24.05.2016\Ciclo1-1de2';
                    obj.folderMatlabCopy = 'G:\CP4RAWCOPY';
                    obj.fileTemplate = {'testeFAlta#','ciclo_2#'};
                otherwise
                    disp('Please input either "CP2", "CP3", or "CP4".')
            end
            
        end
        
        
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
        
        this = trainStreaming(this);
        
        this = adjustCycles(this);
        this = divideClasses(this)
        this = createFrequencyData(this,fs);
        
        this = defineInputs(this);
        
        function propertyMatrix = outputAllProperties(this)
            fields = this.Waves(1,1).fields;
            propertyMatrix = zeros(length(fields)-1, this.countWaveform);
            
            for k=2:length(fields)
                propertyMatrix(k-1,:) = this.propertyVector(fields{k});
            end
        end
    end
end