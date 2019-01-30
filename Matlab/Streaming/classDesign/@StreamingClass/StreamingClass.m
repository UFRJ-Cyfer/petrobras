classdef StreamingClass
    % The main class, it holds all information regarding an AE streaming test.
    %
    % 
%    
%        :param Waves: A holder for all waves captured throughout the test.
%        :type Waves: Wave Array
%
%        :param StreamingModel: Used for all modelling purposes, holds inputs, targets, etc.
%        :type StreamingModel: StreamingModel Object
%
%        :param hdt: Timing parameter, in seconds (Check PAC Manual).
%        :type hdt: double
%
%        :param hlt: Timing parameter, in seconds (Check PAC Manual).
%        :type hlt: double
%
%        :param pdt: Timing parameter, in seconds (Check PAC Manual).
%        :type pdt: double
%
%        :param countWaveform: Amount of captured Waveforms
%        :type countWaveform: double
%
%        :param spIndexes: Contains all indexes of the NP class. (sp -> NP)
%        :type spIndexes: double Array
%
%        :param peIndexes: Contains all indexes of the SP class. (pe -> SP)
%        :type peIndexes: double Array
%
%        :param piIndexes: Contains all indexes of the UP class. (pi -> UP)
%        :type piIndexes: double Array
%
%        :param timePE:  Starting time for SP class in seconds. (pe -> SP)
%        :type timePE: double
%
%        :param timePI:  Starting time for UP class in seconds. (pi -> UP)
%        :type timePI: double
%
%        :param cycleDividers: Holds which files are the cycle dividers, concerning the streaming files.
%        :type cycleDividers: double Array
%
%        :param adjusted: Flag that indicates if the time parameters were already adjusted.
%        :type adjusted: Bool
%
%        :param noiseLevelMatrix: Variable that holds the noise level per file per channel. Each component of the array corresponds to a diffent cycle (demarked by cycleDividers).
%        :type noiseLevelMatrix: Cell Array
%
%        :param fields: An array of fixed strings for each Wave object parameter.
%        :type fields: Cell Array
%
%        :param description: A description for the test.
%        :type description: string
%
%        :param folderTDMS: Holds which folders the TDMS files are. MUST BE ABSOLUTE PATH.
%        :type folderTDMS: Cell Array
%
%        :param folderMatlabCopy: Path for the local .mat files copied from the streaming files.
%        :type folderMatlabCopy: string
%
%        :param fileTemplate: Strings that specify the filename format. Used for reading the TDMS or .mat local files.
%        :type fileTemplate: Cell Array
%
%        :param TOFDReferenceChannel: Holds which streaming channel is the reference when calculating time delays between channels.
%        :type TOFDReferenceChannel: double
%
%        :param sortedFolder: Variable used ONLY for the CP4 test. It tells which file is in which folder. This is needed since the files for CP4 are split between two folders and in a somewhat-random order. 
%        :type sortedFolder: double Array
%
%        :param totalFiles: Total files for each nominated cycle (demarked by cycleDividers).
%        :type totalFiles: double Array
%
%        :param numBitsFileChannel: An array which each element is a matrix of the bit resolution per file and channel of each cycle (demarked by cycleDividers).
%        :type numBitsFileChannel: Cell Array
%
%        :param numUniqueElementsChannel: The same as numBitsFileChannel, but with the total amount of digital levels used instead of bits.
%        :type numUniqueElementsChannel: Cell Array
%
%        :param filesToSkip: An array of lists that holds which files to skip when reading the test. Filled manually.
%        :type filesToSkip: Cell Array
%
%        :param tofdDifferences: Variable that holds which channels to remove TOFD from, and how they are related, that is, how they are delayed in relation to each other.
%        :type tofdDifferences: struct
%
%        :param minBits: The minimum acceptable bits level for inspecting a TDMS file for waves.
%        :type minBits: double
%
%        :param power: Matrix with the single-sided power spectrum for each wave.
%        :type power: double array
%
%        :param normalizedPower: Matrix with the normalized single-sided power spectrum for each wave.
%        :type normalizedPower: double array
%
%        :param phase: Matrix with the phase for each wave.
%        :type phase: double array
%
%        :param frequencyArray: An array with each frequency. 
%        :type frequencyArray: double array
%
%        :param freqSlots: Array with the frequency slots used to generate the frequency inputs for the model.
%        :type freqSlots: double
%

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
        DEBUG_lastIndexArray = [];
        
        TOFDReferenceChannel = [];
        sortedFolder = [];

        totalFiles = [];
        numBitsFileChannel = {};
        numUniqueElementsChannel = {};
        filesToSkip = {};
        tofdDifferences = {};
        minBits = 8;
        channelDelays = {};
        
        
        power = [];
        normalizedPower = [];
        phase = [];
        frequencyArray = [];
        freqSlots = [];
        
    end
    methods
        function obj = StreamingClass(CPString, varargin)
            % The main constructor for the whole project. Instantiates a StreamingClass object that holds everything necessary to read and analyse all TDSM files related to an acoustic emission test. All parameters were defined to ensure the best usage. Some can be changed, like timePE. Others however, can not, as changing them will completely break the constructor, or heavily endanger the quality of the collected data.
            %
            % :param CPString: String to control which test to start analysing. Can be either 'CP2', 'CP3' or 'CP4'.
            % :type CPString: string
            %
            % :param varargin: Can be used to specify which cycle/file combination to start. Must be (initialCycle, initialFile), otherwhise initialFile = 1.
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
                    obj.channelDelays{1} = [13750708 467074 4354081 6413183 6413080 6413524 6413569 254596 6512528 1258094 6443663 6413092 4207266 4207621 4207455 8144784];
                    obj.channelDelays{2} = obj.channelDelays{1};
                    obj.channelDelays{3} = obj.channelDelays{1};
                    %                     rawData = CP2.readFile(1,285);
                    %                     figure(2); plot(rawData(:,11))
                    
                    obj.filesToSkip{1} = [1:183, 196, 197, 340, 359, 360 400 ...
                        417,418 574 575 592 593 629 645 646 680 681 698 699];
                    
                    obj.filesToSkip{2} = [114 115 132 133 168 169 185 186 216 234 235 377 396 397];
                    obj.filesToSkip{3} = [16 17 35 36 61 81 82 40 41 220 ...
                        240 241 242 266 265 287 288 313 326:400];
                    
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
                    
                    obj.channelDelays{1} =  [12274050 12271327 12258165 12258580 12246288 12243570 12249792 12256236 2048286 12228586 12230345 12226524 12218017 12212732 12215748 12213414];
                    
                    obj.filesToSkip{1} = [1:155, 187:224, 255, 256, 272, 273, 305, 321, 320, 453, ...
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
                    
                    obj.channelDelays{1} = [4511856 4519057 4527360 4532962 4571300 4557391 4513655 4522758 4514775 4538602 4494527 4504632 4515962 4504726 4511583 4526034];
                    obj.channelDelays{2} =  obj.channelDelays{1};
                    
                    obj.filesToSkip{1} = [1:155, 191, 192, 261,320,321, 331 ,365,...
                        458, 542, 543, 640,...
                        727, 728, 828, 893, 894, 904, 925, 926, 1023, ...
                        1060, 1061, 1073, 1074, 1129, 1340, ...
                        1427, 1428, 1439, 1486, 1584, 1585, 1604, 1605, 1622, 1670];
                    
                    obj.filesToSkip{2} = [1:155, 211, 212, 284, 283, 381, 382,...
                        477, 555, 556, 657, 658, 706, 707, 718, 744, 745, 852, 853, 880, 881,...
                        894, 908, 923, 924, 937, 938, 951, 1007, 1026, 1027, ...
                        1043, 1044, 1073,1086, 1110, 1111,...
                        1167, 1194, 1195, 1209, 1241, 1253, 1254, 1271, 1325, 1326, ...
                        1362, 1382, 1622, 1634, 1948];
                    
                otherwise
                    disp('Please input either "CP2", "CP3", or "CP4".')
            end
            initialCycle = 1;
            initialFile = 1;
            
            if nargin == 3
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
        propertyArray = propertyVector(this, propertyString)

        [this, lastIndex] = identifyWaves(this, rawData, channels, fs, noiseLevel, ...
            fileNumber, lastIndex, backupPath, cycle)
        
        this = trainStreaming(this)
        
        this = adjustCycles(this)
        this = divideClasses(this)
        this = createFrequencyData(this,fs)
        this = verifyStreamingResolution(this, cycle, initialFile)
        [] = verifyAllWaves(this,indexes,varargin)
        [this, inputMatrix] = defineInputs(this)
        differentWaves = identifySameWaves(this)
        this = readStreaming(this, varargin)
        
        rawData = readFile(this,cycle, fileNumber)
        function propertyMatrix = outputAllProperties(this)
            fields = this.Waves(1,1).fields;
            propertyMatrix = zeros(length(fields)-1, this.countWaveform);
            
            for k=2:length(fields)
                propertyMatrix(k-1,:) = this.propertyVector(fields{k});
            end
        end
    end
end