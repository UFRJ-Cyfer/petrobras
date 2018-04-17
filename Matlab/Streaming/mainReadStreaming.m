diary('log_20180405.txt')
fs = 2.5e6; % streaming sampling frequency (Hz)
f = 75e3; % low pass cutoff frequency (Hz)
startingTime = 0;
fileDeltaTime = 2^24/fs;
examinate = 1;
noiseLevelMatrix = zeros(2000,17);

% path = 'J:';
inicialFile = [1 1 1 0 0 1 1];
finalFile = [754 400 360 0 0 2296 538];
interpolateTwoVector = [1 2 4 8 16 32 64 128 256 516 1024 2048 4096 8192 16384];
readFiles = 0;

files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#',...
    'IDR2_ensaio_03#','ciclo_2#','testeFAlta#','testeFAlta#'};

paths = {'K:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'K:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'K:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'N:\CP3\Ciclo1',...
    'M:\CP4-24.05.2016\Ciclo2-1de1',...
    'M:\CP4-24.05.2016\Ciclo1-1de2', ...
    'L:\CP4-24.05.2016\Ciclo1-2de2'};

desc = {'CP2_ciclo_1_1', 'CP2_ciclo_1_2', 'CP2_ciclo_1_3',...
    'CP3_Ciclo_1','CP4_Ciclo_2','CP4_Ciclo_1_1','CP4_Ciclo_1_2'};

if readFiles == 1
    for cpNumber = 7
        
        %         numFiles = finalFile(cpNumber) - inicialFile(cpNumber) + 1;
        %
        %         numBitsFileChannel = zeros(numFiles,16);
        %         numUniqueElementsChannel = numBitsFileChannel;
        fileID = 438;
        index = 1;
        %     for fileNumber = inicialFile(cpNumber):finalFile(cpNumber)
        for fileNumber = filesRemaining
            fileNumber
            
            filename = [files{cpNumber} num2str(fileNumber,'%03d') '.tdms'];
            %converter
            rawData = readStreamingFile( filename, paths{cpNumber} );
            
            % %filtering
            % [filteredNewMA] = filterStreaming(rawData, fs, f, fileNumber);
            % meanSignal = mean(rawData,1);
            %
            % for k=1:16
            %     figure;
            %     plot(rawData(:,k),'.'); hold on;
            %     title(['channel' num2str(k)])
            % %     plot(meanSignal(k)*ones(size(rawData(:,k))),'LineWidth',1.5);
            % %     plot(1.5*abs(meanSignal(k))*ones(size(filteredNewMA(:,k))),'LineWidth',1.5);
            % %     plot(2.0*abs(meanSignal(k))*ones(size(filteredNewMA(:,k))),'LineWidth',1.5);
            % %     plot(2.5*abs(meanSignal(k))*ones(size(filteredNewMA(:,k))),'LineWidth',1.5);
            % %     legend('Sinal', '\mu', '1.5\mu', '2.0\mu' ,'2.5\mu','Interpreter','tex')
            % ylabel('Amplitude (V)')
            % xlabel('Amostras')
            % %     legend('Sinal', '\mu','Interpreter','tex')
            % end
            
            %     figure;
            %     subplot(1,2,1)
            %     plot(filteredNewMA(:,1),rawData(51:end,4))
            %     xlabel('tempo (s)')
            %     title('canal 4 raw')
            %
            %     subplot(1,2,2);
            %     figure;
            %     plot(filteredNewMA(:,4))
            %     title('canal 4 filtrado')
            %     xlabel('tempo (s)')
            %
            
            
            %     fileID = 1;
            %
            %     for channel=1:16
            %         numUniqueElements = length(unique(rawData(:,channel)));
            %
            %         numUniqueElementsFitted = interp1(interpolateTwoVector, interpolateTwoVector, numUniqueElements, 'next');
            %         numberOfBits = find(numUniqueElementsFitted == interpolateTwoVector) - 1;
            %
            %         numBitsFileChannel(fileID,channel) = numberOfBits;
            %         numUniqueElementsChannel(fileID,channel) = numUniqueElements;
            %     end
            %
            
            if ~isempty(rawData)
                tic
                for channel=1:16
                    numUniqueElements = length(unique(rawData(:,channel)));
                    
                    numberOfBits =(find(numUniqueElements <= interpolateTwoVector,1) - 1);
                    
                    
                    numBitsFileChannel(fileID,channel) = numberOfBits;
                    numUniqueElementsChannel(fileID,channel) = numUniqueElements;
                end
                toc
                fileID = fileID+1;
            end
            index = index+1;
        end
        % waves = identifyWaves(filteredNewMA, fs);
        
        save(['bitsPerChannelCP4Ciclo_1_Parte' num2str(cpNumber-5)],'numBitsFileChannel','numUniqueElementsChannel')
    end
    %saving struct
end

% save(['bitsPerChannelCP4Ciclo_1'],'numBitsFileChannel','numUniqueElementsChannel','sortedFolder')

if examinate
    
    CPtoExaminate = {'bitsPerChannelCP2_Ciclo1','bitsPerChannelCP2_Ciclo1_2','bitsPerChannelCP3','bitsPerChannelCP4','bitsPerChannelCP4Ciclo_1'};
    files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','IDR2_ensaio_03#','ciclo_2#','testeFAlta#'};
    
    paths = {'J:\EnsaioIDR02-2\SegundoTuboStreaming', ...
        'J:\EnsaioIDR02-2\SegundoTuboStreaming',...
        'M:\CP3\Ciclo1',...
        'O:\CP4-24.05.2016\Ciclo1-1de2',...
        'N:\CP4-24.05.2016\Ciclo1-2de2'};
    
    desc = {'CP2_Ciclo_1', ...
        'CP2_Ciclo_2',...
        'CP3_Ciclo_1',...
        'CP4_Ciclo_2',...
        'CP4_Ciclo_1'};
    
    initialNumBits = 7;
    finalNumBits = 14;
    importantData  =[];
    channels = 1:16;
    fs = 2.5e6;
    downsamplingFactor = 1;
    fileLength = 16777216;
    startingColumn = 1;
    endColumn = 0;
    
    waveTime = 17e-3;
    
    waveSize = waveTime*fs;
    collectWaves = 1;
    
    streamingStruct(1).deltaTime = downsamplingFactor / fs;
    removeCompressorFiles = 1;
    
%     filesToSkip = [1:144, 145, 187:224, 255, 256, 272, 273, 305, 321, 320, 453, ...
%         454, 471, 498, 499, 514 ,515, 543, 558, 559, 669, 670, 686,...
%         687, 711, 729, 751, 769, 770, 883, 902, 903, 921, 941, 942,...
%         1046, 1068, 1083, 1109, 1110, 1217, 1250, 1264, 1297, 1397]; CP3

    filesToSkip=[1:144];
    
    load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\tofdDiferencesCP4.mat')
    lastIndexArray = ones(1,16);
    
lastIndexArray = lastIndexArray * ceil(2.5e6*1e-3) * -1;
    for k=5
        streamingObj = StreamingClass();
        load([CPtoExaminate{k} '.mat'])
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
                if k == 5
                    if sortedFolder(filesToCheck(l)) == 1
                        rawData = readStreamingFile( filename, paths{k-1} );
                    else
                        rawData = readStreamingFile( filename, paths{k} );
                    end
                else
                    rawData = readStreamingFile( filename, paths{k} );
                    
                end
                
                [ ~, noiseLevel, slots] =  removeTOFD( rawData,13);
                noiseLevelMatrix(noiseLevelIndex,1) = filesToCheck(l);
                noiseLevelMatrix(noiseLevelIndex,2:end) = noiseLevel;
                noiseLevelIndex = noiseLevelIndex+1;
                
                for j=channels
                    hasChannel = find(tofdDiferences.channels == j);
                    if ~isempty(hasChannel)
                        newSlots = slots+tofdDiferences.deltaIndexes(hasChannel);
                        newSlots(newSlots<=0) = 1;
                        newSlots(newSlots>16777216) = 16777216;
                        rawData(newSlots,j) = NaN;
                    end
                end
                
                [streamingObj, lastIndexArray] = streamingObj.identifyWaves(rawData,...
                    channels(boolMatrix(filesToCheck(l),:)), fs, ...
                    noiseLevel, filesToCheck(l), lastIndexArray);
                
                
                elapsedTime = toc;
                fprintf('File analyzed in %.3f seconds \n', elapsedTime)
            end
            
            
        end
        %         streamingStruct(k).noiseLevelMatrix = noiseLevelMatrix;
        diary off

                save(['streamingOBJv73' desc{k}],'streamingObj','-v7.3')
                save(['streamingOBJ' desc{k}],'streamingObj')
    end
    
    
end
