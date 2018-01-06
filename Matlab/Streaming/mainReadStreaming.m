fs = 2.5e6; % streaming sampling frequency (Hz)
f = 75e3; % low pass cutoff frequency (Hz)
startingTime = 0;
fileDeltaTime = 2^24/fs;
examinate = 1;
noiseLevelMatrix = zeros(2000,17);

% path = 'J:';
inicialFile = [1 1 1 0 0 1 1];
finalFile = [754 400 360 0 0 1758 538];
interpolateTwoVector = [1 2 4 8 16 32 64 128 256 516 1024 2048 4096 8192 16384];
readFiles = 0;

files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#',...
    'IDR2_ensaio_03#','ciclo_2#','testeFAlta#','testeFAlta#'};

paths = {'K:\EnsaioIDR02-2\SegundoTuboStreaming', 'K:\EnsaioIDR02-2\SegundoTuboStreaming', 'K:\EnsaioIDR02-2\SegundoTuboStreaming',...
    'L:\CP3\Ciclo1','M:\CP4-24.05.2016\Ciclo2-1de1','M:\CP4-24.05.2016\Ciclo1-1de2','L:\CP4-24.05.2016\Ciclo1-2de2'};

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
    paths = {'J:\EnsaioIDR02-2\SegundoTuboStreaming', 'J:\EnsaioIDR02-2\SegundoTuboStreaming', 'N:\CP3\Ciclo1','M:\CP4-24.05.2016\Ciclo1-1de2','L:\CP4-24.05.2016\Ciclo1-2de2'};
    desc = {'CP2_Ciclo_1', 'CP2_Ciclo_2', 'CP3_Ciclo_1','CP4_Ciclo_2','CP4_Ciclo_1'};
    
    initialNumBits = 8;
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
    
    for k=3
        load([CPtoExaminate{k} '.mat'])
        for numMinBits = initialNumBits
            boolMatrix = (numBitsFileChannel >= numMinBits);
                  
            numericMatrix = 1*boolMatrix;
            
            numberOfFiles = sum(sum(boolMatrix,1),2);
                        
            filesToCheck = (sum(boolMatrix,2) > 0);
            auxVec = (1:length(filesToCheck));
            
            filesToCheck = filesToCheck.*auxVec';
            filesToCheck = filesToCheck(filesToCheck~=0);
            
            if collectWaves
                
                %              streamingStruct(k).rawData = zeros(waveSize, 50*numberOfFiles,'int16');
                
            else
                %            streamingStruct(length(files)).rawData = importantData;
            end
            
            %         streamingStruct(k).startingTime = zeros(1,50*numberOfFiles);
            %         streamingStruct(k).fileNumber = zeros(1,50*numberOfFiles);
            %         streamingStruct(k).channel = zeros(1,50*numberOfFiles);
            %         streamingStruct(k).resolution = zeros(1,50*numberOfFiles);
            
            noiseLevelIndex = 1;
            for l=1:length(filesToCheck)
                
                %                 if k==3 && (filesToCheck(l) == 801 || filesToCheck(l) == 1421)
                %                     filesToCheck(l) = filesToCheck(l) + 1;
                %                 end
                
                filename = [files{k} num2str(filesToCheck(l),'%03d') '.tdms'];
                if k == 4
                    if sortedFolder(filesToCheck(l)) == 1
                        rawData = readStreamingFile( filename, paths{k-1} );
                    else
                        rawData = readStreamingFile( filename, paths{k} );
                    end
                else
                    rawData = readStreamingFile( filename, paths{k} );
                    
                end
                
                [ ~, noiseLevel, slots] = removeTOFD( rawData,12);
                noiseLevelMatrix(noiseLevelIndex,1) = filesToCheck(l);
                noiseLevelMatrix(noiseLevelIndex,2:end) = noiseLevel;
                noiseLevelIndex = noiseLevelIndex+1;
                for j=channels
                    hasChannel = find(tofdDiferences.channels == j);
                    if ~isempty(hasChannel)
                        newSlots = slots+tofdDiferences.deltaIndexes(hasChannel);
                        newSlots(newSlots<=0) = 1;
                        newSlots(newSlots>16777216) = 16777216;
                        rawData(newSlots,j) = 0;
                    end
                end
                
                [waves, startingTimes, triggerTime]= identifyWaves(rawData,channels(boolMatrix(filesToCheck(l),:)), fs,noiseLevel);
                endColumn = endColumn + size(waves,2);
                
                
                streamingStruct(k).rawData(:,startingColumn:endColumn) =  waves(2:end,:);
                
                %             streamingStruct(k).rawData(:,startingColumn:endColumn) =  rawData(1:downsamplingFactor:fileLength,boolMatrix(filesToCheck(l),:));
                %             streamingStruct(k).channel(startingColumn:endColumn) = channels(boolMatrix(filesToCheck(l),:));
                %             streamingStruct(k).resolution(startingColumn:endColumn) = numBitsFileChannel(filesToCheck(l),boolMatrix(filesToCheck(l),:));
                %             streamingStruct(k).fileNumber(startingColumn:endColumn) = filesToCheck(l)*ones(1,endColumn-startingColumn+1);
                %             streamingStruct(k).startingTime(startingColumn:endColumn) = (filesToCheck(l)-1)*(fileLength/fs)*ones(1,endColumn-startingColumn+1);
                
                
                streamingStruct(k).channel(startingColumn:endColumn) = waves(1,:);
                streamingStruct(k).resolution(startingColumn:endColumn) = numBitsFileChannel(filesToCheck(l),waves(1,:));
                streamingStruct(k).fileNumber(startingColumn:endColumn) = filesToCheck(l)*ones(1,endColumn-startingColumn+1);
                streamingStruct(k).startingTime(startingColumn:endColumn) = (filesToCheck(l)-1)*(fileLength/fs) + startingTimes;
                streamingStruct(k).triggerTime(startingColumn:endColumn) = (filesToCheck(l)-1)*(fileLength/fs) + triggerTime;
                
                streamingStruct(k).description = desc{k};
                startingColumn = endColumn+1;
            end
            
            
        end
        streamingStruct(k).noiseLevel = noiseLevelMatrix;
        save(['streamingStructReduced' desc{k}],'streamingStruct','-v7.3')
    end
    
    
    % auxStreamingStruct = streamingStruct(3).rawData(:,1:73437);
    %
    % streamingStruct(3).startingTime(:,73438:end) = [];
    % streamingStruct(3).fileNumber(:,73438:end) = [];
    % streamingStruct(3).channel(:,73438:end) = [];
    % streamingStruct(3).resolution(:,73438:end) = [];
    %
    %
    % streamingStruct(4).startingTime(:,1517:end) = [];
    % streamingStruct(4).fileNumber(:,1517:end) = [];
    % streamingStruct(4).channel(:,1517:end) = [];
    % streamingStruct(4).resolution(:,1517:end) = [];
    %
    %
    % columnsWithoutWaves = find(streamingStruct(4).rawData(1,:) == 0)
    % columnsWithoutWaves(1)
    % streamingStruct(4).rawData(:,1517:end) = [];
    %
    %     streamingStruct(3).rawData = streamingStruct(3).rawData(:,1:73437);
    %
    %          save(['streamingStructCleaned'],'streamingStruct','-v7.3')
end
%     end
%     for k=[3 9 15 25 70]
%        figure
%        plot(streamingStruct(3).rawData(:,k))
%     end
%
%     for l=5:7
%         figure;
%         plot(streamingStruct(4).rawData(:,l))
%     end
%
%     histogram(numBitsFileChannel(:,8))
%     xlabel('Número de Bits')
%     xlim([3 13])
% timeVector = 0:1:42499;
% timeVector= timeVector*4e-7;
% figure;
% for k=1:16
%     subplot(4,4,k)
%     plot(timeVector,mean(streamingStruct(3).rawData(:, streamingStruct(3).channel == k),2))
%     title(['Med Canal' num2str(k)])
% end
%
% figure;
% plot(max(streamingStruct(3).rawData,[],1))
%
%
% figure;
% plot(max(streamingStruct(3).rawData(:, streamingStruct(3).channel ~= 6),[],1))
%
% indexVector = 1:size(streamingStruct(3).rawData,2);
% indexVector = indexVector(streamingStruct(3).channel ~= 6);
%
% figure;
% plot(streamingStruct(3).rawData(:,indexVector(1493)))
% %
% 
% [ cleanedRawData, noiseLevel] = removeTOFD( rawData,1:16);
% 
% 
% figure;
% for k_=1:16
%    plot(rawData(1.35e6:1.65e6,k_)); hold on;
% end
% legend('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16');