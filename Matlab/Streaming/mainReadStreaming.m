% clear all
diary(['log_' date '__.txt'])
fs = 2.5e6; % streaming sampling frequency (Hz)
f = 75e3; % low pass cutoff frequency (Hz)
startingTime = 0;
fileDeltaTime = 2^24/fs;
examinate = 1;
noiseLevelMatrix = zeros(2000,17);

% path = 'J:';
inicialFile = [390 1 1 2254 151 1 1];
finalFile = [754 400 360 2294 1967 2296 538];
interpolateTwoVector = [1 2 4 8 16 32 64 128 256 516 1024 2048 4096 8192 16384];
readFiles = 0;

files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#',...
    'IDR2_ensaio_03#','testeFAlta#','ciclo_2#'};

paths = {'L:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'L:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'L:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'N:\CP3\Ciclo1',...
    'N:\CP4-24.05.2016\Ciclo1-2de2',...
    'O:\CP4-24.05.2016\Ciclo1-1de2', ...
    'O:\CP4-24.05.2016\Ciclo2-1de1'};

    backupPath = {'G:\CP2RAWCOPY','G:\CP2RAWCOPY','G:\CP2RAWCOPY',...
        'J:\BACKUPJ\ProjetoPetrobras\CP3RAWCOPY',...
        'J:\BACKUPJ\ProjetoPetrobras\CP4RAWCOPY',...
        'G:\CP4RAWCOPY'};

desc = {'CP2_Ciclo_1_1', 'CP2_Ciclo_1_2', 'CP2_Ciclo_1_3',...
    'CP3_Ciclo_1','CP4_Ciclo_1','CP4_Ciclo_2'};

sortedFolder = [];
initialNumBits = 8;

if readFiles == 1
    for k = [1,2,3]
        if k >1
        numBitsFileChannel = zeros(finalFile(k),16);
        numUniqueElementsChannel = numBitsFileChannel;
        end
        
        for fileNumber = inicialFile(k):finalFile(k)
            fileNumber
            filename = [files{k} num2str(fileNumber,'%03d') '.tdms'];
            %converter
            
            if sortedFolder
                if sortedFolder(fileNumber) == 2 && k==4
                    rawData = readStreamingFile( filename, paths{k-1} , backupPath{k}, 0);
                else
                    rawData = readStreamingFile( filename, paths{k} , backupPath{k}, 0);
                end
            else
                rawData = readStreamingFile( filename, paths{k} , backupPath{k}, 0);
                
            end
            
            if ~isempty(rawData)
                tic
                for channel=1:16
                    numUniqueElements = length(unique(rawData(:,channel)));
                    
                    numberOfBits =(find(numUniqueElements <= interpolateTwoVector,1) - 1);
                    
                    
                    numBitsFileChannel(fileNumber,channel) = numberOfBits;
                    numUniqueElementsChannel(fileNumber,channel) = numUniqueElements;
                end
                toc
            end
            if ~isempty(find(numberOfBits >= numBitsFileChannel(fileNumber,:),1))
                save([backupPath{k} '\' filename(1:end-4) 'mat'],'rawData')
            end
        end
        
        save(['bitsPerChannel' desc{k}],'numBitsFileChannel','numUniqueElementsChannel')
    end
    %saving struct
end

if examinate
    
    CPtoExaminate = {'bitsPerChannelCP2_Ciclo_1_1','bitsPerChannelCP2_Ciclo_1_2','bitsPerChannelCP2_Ciclo_1_3','bitsPerChannelCP3','bitsPerChannelCP4Ciclo_1', 'bitsPerChannelCP4_Ciclo_2'};
    files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#','IDR2_ensaio_03#','testeFAlta#','ciclo_2#'};
    
    paths = {'L:\EnsaioIDR02-2\SegundoTuboStreaming', ...
        'L:\EnsaioIDR02-2\SegundoTuboStreaming',...
        'L:\EnsaioIDR02-2\SegundoTuboStreaming',...
        'M:\CP3\Ciclo1',...
        'O:\CP4-24.05.2016\Ciclo1-1de2',... #essa linha tem que ser modificada pra k =5
        'N:\CP4-24.05.2016\Ciclo1-2de2',...
        'O:\CP4-24.05.2016\Ciclo2-1de1'};
    
    
    desc = {'CP2_Ciclo_1', ...
        'CP2_Ciclo_2',...
        'CP2_Ciclo_3',...
        'CP3_Ciclo_1',...
        'CP4_Ciclo_1',...
        'CP4_Ciclo_2'};
    
    initialNumBits = 8;
    finalNumBits = 14;
    importantData  =[];
    channels = 1:16;
    fs = 2.5e6;
    downsamplingFactor = 1;
    fileLength = 16777216;
    startingColumn = 1;
    endColumn = 0;
    TOFDReferenceChannel = 6;
    
    waveTime = 17e-3;
    
    waveSize = waveTime*fs;
    collectWaves = 1;
    
    streamingStruct(1).deltaTime = downsamplingFactor / fs;
    removeCompressorFiles = 1;
    %
    %     filesToSkip = [1:150, 187:224, 255, 256, 272, 273, 305, 321, 320, 453, ...
    %         454, 471, 498, 499, 514 ,515, 543, 558, 559, 669, 670, 686,...
    %         687, 711, 729, 751, 769, 770, 883, 902, 903, 921, 941, 942,...
    %         1046, 1068, 1083, 1109, 1110, 1217, 1250, 1264, 1297, 1397]; %CP3
    %
    %     filesToSkip = [1:150, 191, 192, 261, 542,543, 727, 728, 893, 894, 925, 926, ...
    %         1060, 1061, 1427, 1428, 1604, 1605, 1:2256];%CP4C1
    
    %     for l=filesToSkip
    %         filename = [files{k} num2str(181,'%03d') '.tdms'];
    %         rawData = readStreamingFile( filename, paths{k} , backupPath{k});
    %         figure(6);plot(rawData(:,12))
    %         title(num2str(l))
    %         pause;
    %     end
    %
    %     filesToSkip = [1:150, 381, 382, 477, 555, 556, 706, 707, 718, 744, 745, 852, 853, 880, 881,...
    %         894, 923, 924, 937, 938, 951, 1026, 1027,  1110, 1111,...
    %         1167, 1194, 1195, 1209, 1241, 1325, 1326, 1362 ];%CP4C2
    %
    
%       filesToSkip = [1:183, 196, 197, 417,418]; %CP2C1
%       filesToSkip = [114 115 132 133 168 169 185 186 234 235 377 396 397 ]; %CP2C2
%       filesToSkip = [16 17 35 36 81 82 40 41 287 288 326:400]; %CP2C3
%     
%     for k=1:length(filesToSkip)
%         fileArray = streamingObj.propertyVector('file');
%         streamingObj.Waves(fileArray == filesToSkip(k)) = [];
%     end
%     
    filesToSkip=[0];
    
    lastIndexArray = ones(1,16);
    

    
    lastIndexArray = lastIndexArray * ceil(2.5e6*1e-3) * -1;
    for k=[3]
        streamingObj = StreamingClass();
        streamingObj.fileTemplate = files{k};
        streamingObj.folderTDMS = paths{k};
        load([CPtoExaminate{k} '.mat'])
        if k>=1 || k<=3
            load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\tofdDifferencesCP2.mat')
        end
        if k==5
            load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\tofdDifferencesCP4C2.mat')
        end
        if k==4
            load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\tofdDifferencesCP4.mat')
        end
        for numMinBits = initialNumBits
            boolMatrix = (numBitsFileChannel >= numMinBits);
            
            numericMatrix = 1*boolMatrix;
            
            numberOfFiles = sum(sum(boolMatrix,1),2);
            
            filesToCheck = (sum(boolMatrix,2) > 0);
            auxVec = (1:length(filesToCheck));
            
            filesToCheck = filesToCheck.*auxVec';
            filesToCheck = filesToCheck(filesToCheck~=0);
            
            
            if removeCompressorFiles
                [~,ia,ib] = intersect(filesToCheck, filesToSkip);
                filesToCheck(ia) = [];
            end
            
            
            noiseLevelIndex = 1;
            for l=1:length(filesToCheck)
                
                tic
                fprintf(['Now verifying file %i\n'], filesToCheck(l))
                filename = [files{k} num2str(filesToCheck(l),'%03d') '.tdms'];
                
                if k == 4
                    if sortedFolder(filesToCheck(l)) == 1
                        rawData = readStreamingFile( filename, paths{k-1} , backupPath{k});
                    else
                        rawData = readStreamingFile( filename, paths{k} , backupPath{k});
                    end
                else
                    rawData = readStreamingFile( filename, paths{k} , backupPath{k});
                    
                end
                
                [ ~, noiseLevel, slots] =  removeTOFD( rawData,TOFDReferenceChannel);
                noiseLevelMatrix(noiseLevelIndex,1) = filesToCheck(l);
                noiseLevelMatrix(noiseLevelIndex,2:end) = noiseLevel;
                noiseLevelIndex = noiseLevelIndex+1;
                
                for j=channels
                    if noiseLevel(j) < 500
                        hasChannel = find(tofdDifferences.channels == j);
                        if ~isempty(hasChannel)
                            newSlots = slots+tofdDifferences.deltaIndexes(hasChannel);
                            newSlots(newSlots<=0) = 1;
                            newSlots(newSlots>16777216) = 16777216;
                            rawData(newSlots,j) = NaN;
                        end
                    end
                end
                
                [streamingObj, lastIndexArray] = streamingObj.identifyWaves(rawData,...
                    channels(boolMatrix(filesToCheck(l),:)), fs, ...
                    noiseLevel, filesToCheck(l), lastIndexArray,backupPath{k});
                
                
                elapsedTime = toc;
                fprintf('File analyzed in %.3f seconds \n', elapsedTime)
            end
            
            
        end
        streamingOBJ.noiseLevelMatrix = noiseLevelMatrix;
        diary off
        
        save(['streamingOBJv73' desc{k}],'streamingObj','-v7.3')
        save(['streamingOBJ' desc{k}],'streamingObj')
    end
end

