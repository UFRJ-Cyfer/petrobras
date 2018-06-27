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
        
        TOFDReferenceChannel = [];
        sortedFolder = [];
        numMinBits = [];
        
        totalFiles = [];
        numBitsFileChannel = {};
        numUniqueElementsChannel = {};
        filesToSkip = {};
        tofdDifferences = {};
        minBits = 8;
        
        
        power = [];
        normalizedPower = [];
        phase = [];
        frequencyArray = [];
        freqSlots = [];
        
    end
    methods
        function obj = StreamingClass(CPString, varargin)
            
            switch CPString
                case 'CP2'
                    obj.timePE = 3000;
                    obj.timePI = 9500;
                    obj.description = 'CP2';
                    obj.folderTDMS = {'L:\EnsaioIDR02-2\SegundoTuboStreaming'};
                    obj.folderMatlabCopy = 'G:\CP2RAWCOPY';
                    obj.fileTemplate = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#'};
                    obj.TOFDReferenceChannel = 6;
                    obj.totalFiles = [754, 400, 325];
                    
                    load('tofdDifferencesCP2.mat');
                    obj.tofdDifferences{1} = tofdDifferences;
                   
                    obj.filesToSkip{1} = [1:183, 196, 197, 359, 360 417,418 593 646 698 699];
                    obj.filesToSkip{2} = [114 115 132 133 168 169 185 186 216 234 235 377 396 397];
                    obj.filesToSkip{3} = [16 17 35 36 61 81 82 40 41 220 266 265 287 288 326:400];
                    
                case 'CP3'
                    obj.timePE = 3000;
                    obj.timePI = 9000;
                    obj.description = 'CP3';
                    obj.folderTDMS = {'N:\CP3\Ciclo1'};
                    obj.folderMatlabCopy = 'G:\CP3RAWCOPY';
                    obj.fileTemplate = {'IDR2_ensaio_03#'};
                    obj.TOFDReferenceChannel = 12;
                    obj.totalFiles = [1422];
                    
                    load('tofdDifferencesCP3.mat');
                    obj.tofdDifferences{1} = tofdDifferences;
                    
                    
                    obj.filesToSkip{1} = [1:150, 187:224, 255, 256, 272, 273, 305, 321, 320, 453, ...
                        454, 471, 498, 499, 514 ,515, 543, 558, 559, 669, 670, 686,...
                        687, 711, 729, 751, 769, 770, 883, 902, 903, 921, 941, 942,...
                        1046, 1068, 1083, 1109, 1110, 1217, 1250, 1264, 1297, 1397];
                    
                case 'CP4'
                    obj.timePE = 3000;
                    obj.timePI = 20000;
                    obj.description = 'CP4';
                    obj.folderTDMS = {'O:\CP4-24.05.2016\Ciclo1-1de2','O:\CP4-24.05.2016\Ciclo2-1de1', 'N:\CP4-24.05.2016\Ciclo1-2de2'};
                    obj.folderMatlabCopy = 'G:\CP4RAWCOPY';
                    obj.fileTemplate = {'testeFAlta#','ciclo_2#'};
                    obj.TOFDReferenceChannel = 13;
                    obj.totalFiles = [2246, 1963];
                    
                    load('sortedFolderCP4.mat');
                    obj.sortedFolder = sortedFolder;
                    load('tofdDifferencesCP4.mat');
                    obj.tofdDifferences{1} = tofdDifferences;
                    
                    
                    load('tofdDifferencesCP4C2.mat');
                    obj.tofdDifferences{2} = tofdDifferences;
                    
                    
                    
                    obj.filesToSkip{1} = [1:150, 191, 192, 261, 542,543, 727, 728, 893, 894, 925, 926, ...
                        1060, 1061, 1073, 1074, 1427, 1428, 1486, 1584, 1585, 1604, 1605, 1622];
                    obj.filesToSkip{2} = [1:150, 381, 382, 477, 555, 556, 706, 707, 718, 744, 745, 852, 853, 880, 881,...
                        894, 923, 924, 937, 938, 951, 1026, 1027,  1110, 1111,...
                        1167, 1194, 1195, 1209, 1241, 1325, 1326, 1362];
                    
                otherwise
                    disp('Please input either "CP2", "CP3", or "CP4".')
            end
            initialCycle = 1;
            initialFile = 1;
            
            if nargin ==3 
                initialCycle = varargin{1};
                try
                    initialFile = varargin{2};
                catch E
                    initialFile = 1;
                end
            end
            
            for cycle = initialCycle:length(obj.fileTemplate)
                try
                    load(['bitsPerChannel' obj.description '_Ciclo_' num2str(cycle)])
                    obj.numBitsFileChannel{cycle} = numBitsFileChannel;
                    obj.numUniqueElementsChannel{cycle} = numUniqueElementsChannel;
                catch E
                    obj = obj.verifyStreamingResolution(cycle, initialFile);
                end
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
            fileNumber, lastIndex, backupPath, cycle)
        
        this = trainStreaming(this);
        
        this = adjustCycles(this);
        this = divideClasses(this)
        this = createFrequencyData(this,fs);
        this = verifyStreamingResolution(this, cycle, initialFile);
        
        this = defineInputs(this);
        
        rawData = readFile(this,cycle, fileNumber);
        function propertyMatrix = outputAllProperties(this)
            fields = this.Waves(1,1).fields;
            propertyMatrix = zeros(length(fields)-1, this.countWaveform);
            
            for k=2:length(fields)
                propertyMatrix(k-1,:) = this.propertyVector(fields{k});
            end
        end
    end
end