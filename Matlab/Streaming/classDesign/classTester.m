% % % wave1 = Wave;
% % % wave2 = Wave;
% % % 
% % % wave1.duration = 1;
% % % wave2.duration = 2;
% % % 
% % % strClass = StreamingClass;
% % % 
% % % strClass = strClass.addWave(wave1);
% % % strClass = strClass.addWave(wave2);
% % % 
% % % sum([strClass.Waves.duration])
% % % 
% % % 
% % % 
% % % rawData = readStreamingFile( filename, paths{k} );
% % 
% % streamingObj = StreamingClass();
% % 
% % streamingObj.hdt = 1000e-6;
% % streamingObj.hlt = 1000e-6;
% % streamingObj.pdt = 800e-6;
% % 
% % noiseLevel = zeros(1,12);
% % noiseLevel(7) = 100;
% % 
% % lastIndexArray = ones(1,12);
% % lastIndexArray = lastIndexArray * ceil(2.5e6*1e-3) * -1;
% % 
% % rawData = readStreamingFile( filename, path );
% % %  [ rawDataClean, noiseLevel, slots] = removeTOFD( rawData, 12 );
% % 
% % 
% % [streamingObj lastIndexArray] = streamingObj.identifyWaves(rawData(1:end,:), [7 12], 2.5e6, ...
% %     noiseLevel, 272, lastIndexArray);
% % % 
% %  triggerArray = streamingObj.propertyVector('triggerTime');
% %  durationV = streamingObj.propertyVector('duration');
% %  
% %  figure
% %  plot(rawDataClean(:,12))
% %  hold on;
% %  plot(triggerArray, 400*ones(size(triggerArray)),'.')
% % 
% %  resolutionArray = streamingObj.propertyVector('resolution');
%  rawDataCell = streamingObj.propertyVector('rawData');
% %  
%  rawDataCell(131:end) = [];
% %  
%  waves = {streamingObj.Waves.rawData};
%  
% % figure
% % plot(streamingObj.Waves(1,23).rawData)
% 
% freqSlots = linspace(0, 1.25e6, 2^11);
% partialFrequencyVector = zeros(1,2^12-1);
% 
% 
% for k=1:length(rawDataCell)
%     wave = double(rawDataCell{k});
%     wave = wave(1:end-2500);
%     wave = wave - mean(wave);
%     fftWave = fft(wave)/length(wave);
%     %there is no problem multiplying by 2 here since H(0) = 0
%     fftWave = 2*fftWave(1:(length(wave) - mod(length(wave),2))/2);
%    fftWaves{k} = fftWave;
% end
% 
% 
outputAbs = zeros(length(fftWaves),2^11-1);
outputPhase = outputAbs;
for k=1:length(fftWaves)
    freq = linspace(0,1.25e6, length(fftWaves{k}));
    waveFFT = fftWaves{k};
    for l=1:(length(freqSlots)-1)
       boola = (freq >= freqSlots(l)) & (freq < freqSlots(l+1));
       absFFT = abs(waveFFT);
       phaseFFT = angle(waveFFT);
       outputAbs(k, l) = mean(absFFT(boola));
       outputPhase(k, l) = mean(phaseFFT(boola));
    end
    k
end

figure;
hold off;

maxindex= 330;
plot(freqSlots(1:maxindex),mean(outputPhase(1:83,1:maxindex))/pi); hold on;
plot(freqSlots(1:maxindex),mean(outputPhase(84:113,1:maxindex))/pi)
plot(freqSlots(1:maxindex),mean(outputPhase(114:130,1:maxindex))/pi)
legend('SP', 'PE', 'PI')
title('Fase')
xlabel('Frequência (Hz)')
ylabel('Radiano / \pi')
% % 
% % 
% %  triggerArray = streamingObj.propertyVector('triggerTime');
% %  amplitudeArray = streamingObj.propertyVector('maxAmplitude');
% %  
% %  triggerArray(131:end) = [];
% %  
% %  
% %  timePE = 3000;
% %  timePI = 9000;
% %  
% %  slotsSP = triggerArray < timePE;
% %  slotsPE = triggerArray >= timePE & triggerArray < timePI;
% %  slotsPI = triggerArray >= timePI;
% %  
%  outputAbsolute = abs(output);
% %  normalizedAbsolute = outputAbsolute./repmat(sum(outputAbsolute,2), 1, size(outputAbsolute,2));
% %  
% %  lastIndex = 1e3;
% %  figure;
% %  plot(freqSlots(1:lastIndex),mean(normalizedAbsolute(slotsSP,1:lastIndex),1))
% %  hold on;
% %  plot(freqSlots(1:lastIndex), mean(normalizedAbsolute(slotsPE,1:lastIndex),1))
% %  plot(freqSlots(1:lastIndex),mean(normalizedAbsolute(slotsPI,1:lastIndex),1))
% % legend('SP','PE','PI')
% % 
% % 
% % 
% % output(isnan(output)) = 0;
% % 
% % 
% % 
[mainVallen_] = streamVariableSizeToVallenFormat(streamingObj, outputAbs');
% % 
% corrInputClasses = correlationAnalysis(mainVallen);
% 
% visibleNormalized = 1;
% normalized = 2;
% visible = 'on';
% 
% frequencyDivisions = [];
% energyCrossCorrFigHandles = ...
%     plotCrossCorr(corrInputClasses,mainVallen.frequencyVector,...
%     normalized, visible);
% % 
% % 
% [neuralNetInput, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
%     mainVallen.normalizedEnergy, ...
%     frequencyDivisions, ...
%     energyCrossCorrFigHandles.normalizedEnergy, ...
%     mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
%     corrInputClasses.normalizedEnergy.mergedClasses(:,find(corrInputClasses.gIndexesNormalizedEnergy)),...
%     mainVallen.frequencyVector);
% % 
% method = 'MLP'
% trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method, mainVallen.separationIndexes);
% modelPlotFigureHandle = plotModel(trainedModel);
% % 
% % wavesRaw = {}
% 
% 
% for j=1:3
%     for k=1:3
%         if k~=j
%             cmm(k,j) = -cmm(k,j);
%         end
%     end
% end
% 
% 
% 
% 
% figure
% subplot(2,1,1)
% title('Variavel')
% tt = propertyVector( streamingObj, 'triggerTime' );
% plot(tt, linspace(1,length(tt), length(tt)),'.')
% 
% 
% subplot(2,1,2)
% title('Fixo')
% plot(triggerTime, linspace(1,length(triggerTime),length(triggerTime)),'.')
% 
% 
% 
% 
% indexesToRemove = diff(triggerTime) >= 0.018 & diff(triggerTime) <= 0.022;
% indexesToRemove = diff(triggerTime) >= 0.9 & diff(triggerTime) <= 1.1;
% 
% PARA1(indexesToRemove) = [];
% rise(indexesToRemove) = [];
% rms(indexesToRemove) = [];
% channel(indexesToRemove) = [];
% count(indexesToRemove) = [];
% amplitude(indexesToRemove) = [];
% duration(indexesToRemove) = [];
% triggerTime(indexesToRemove) = [];
% 
% figure
% subplot(2,1,1)
% dd = propertyVector( streamingObj, 'duration' );
% h = histogram(dd,100);
% title('Duration')
% 
% axis([-0.01 0.4 -inf inf])
% 
% 
% subplot(2,1,2)
% histogram(duration/(1e6), h.BinEdges)
% axis([-0.01 0.4 -inf inf])
% title('Duration PAC')
% 
% 
% 
% 
% figure
% subplot(2,1,1)
% rr = propertyVector( streamingObj, 'riseTime' );
% h = histogram(rr,100);
% title('Rise Time')
% 
% axis([-0.01 inf -inf inf])
% 
% 
% subplot(2,1,2)
% histogram(rise/(1e6), h.BinEdges)
% axis([-0.01 inf -inf inf])
% title('Rise Time PAC')
% 
% 
% 
% 
% figure
% subplot(2,1,1)
% cc = propertyVector( streamingObj, 'count' );
% h = histogram(cc,100);
% title('Count')
% 
% axis([-0.01 5000 -inf inf])
% 
% 
% subplot(2,1,2)
% histogram(count, h.BinEdges)
% axis([-0.01 5000 -inf inf])
% title('Count PAC')
% 
% 
% figure
% subplot(2,1,1)
% rrr = propertyVector( streamingObj, 'rms' );
% h = histogram(rrr,100);
% title('RMS')
% 
% axis([-0.01 inf -inf inf])
% 
% 
% subplot(2,1,2)
% histogram(rms, h.BinEdges)
% axis([-0.01 inf -inf inf])
% title('RMS PAC')
% 
% 
% figure
% subplot(2,1,1)
% aa = propertyVector( streamingObj, 'maxAmplitude' );
% aa = double(aa) * (10/(2^13*4))*1000;
% h = histogram(20*log(aa),100);
% title('Amplitude (dB)')
% 
% axis([60 inf -inf inf])
% 
% 
% subplot(2,1,2)
% histogram(amplitude, h.BinEdges)
% axis([60 inf -inf inf])
% title('Amplitude PAC (dB)')
% 
% 
% 
% 
% 
% figure;
% plot(diff(triggerTime))
% 
% 
for k=1:length(streamingObj.Waves)
    
    streamingObj.Waves(k) = streamingObj.Waves(k).calculateParameters(2.5e6, streamingObj);
end

% 
% 
% 
% y_classes = repmat([1;0;0;],1,83);
% y_classes = [y_classes repmat([0;1;0;],1,113-82)];
% y_classes = [y_classes repmat([0;0;1;],1,129-113)];
% 

% fields = fieldnames(streamingObj.Waves);
% 
indexMatrix = 1;
inputMatrix = zeros(12,468);

% [3:7 9:11 13:16 18]
%[3:7 9:11 13 15 17 18]

for k=[3:7 9:11 13 15 17 18]
   
    inputMatrix(indexMatrix,:) = [streamingObj.Waves.(fields{k})];
    indexMatrix=  indexMatrix+1;
end


for k=[3:7 9:11 13 15 17 18]
   
   (fields{k})

end
% 
inputMatrix(:,131:end) = [];

trainedModel = mainTrain...
    ([inputMatrix; neuralNetInput(1:5,:)], mainVallen.sparseCodification, method, mainVallen.separationIndexes);


ap_ = [1 1 1 2 1 1 3 1 1 1 1 3 1 2 3 1 1 1 1 1 1 1 1 3 1 2 1 1 1 2 2 1 1 2 1 1 1 1 2 1 2 2 3 1 1 3 1 2 1 3 1 3 2 1 1 2 1 2 2 1 1 1 3 1 1 2 1 1 2 3 1 1 1 11 2 2 2 3 1 2 1 3 3 1 1 1 2 1 2 2];


for k=1:3
   sum(ap_==k) 
end

figure;
for k=1:100
   plotperform(trainedModel.outputRuns(k).tr)
   pause
end

    inputNormalized = normalizeData(inputMatrix,1);
inputNormalized(:,[102 121]) = [];
inputNormalized(:,[115:end]) = [];

D = pdist(inputNormalized');
Z = squareform(D);
imagesc(Z);

simMatrix = zeros(130);
for k=1:size(inputNormalized,2)
    for j=k:size(inputNormalized,2)
        simMatrix(k,j) = inputNormalized(:,k)'*inputNormalized(:,j)/ ...
            (sqrt(sum(inputNormalized(:,k).^2))*sqrt(sum(inputNormalized(:,j).^2)));
        
        simMatrix(j,k) = simMatrix(k,j);
        
    end    
end
figure;
imagesc(simMatrix);colorbar;
caxis([0 1])

classIndexes = [1, 83, 114, 130];


inoputs = [3:7 9:11 13 15 17 18];
figure(5);
for v = 1:12
    figure(5);
            hold off;
    for l=1:length(classIndexes)-1

        figure(5)
        histogram(inputMatrix(v,classIndexes(l):classIndexes(l+1)-1),50)
        hold on;
        

    end
    legend('SP','PE','PI')
    title(fields{inoputs(v)})
    pause;
end


outputAbs = outputAbs';


outputPhase = outputPhase';
% frequencyDivisions = [1 38 164 227 284 327 372 433 457 591];
% for k=1:length(frequencyDivisions)/2
%     neuralNetInput_(k,:) = mean(outputPhase(frequencyDivisions(2*k-1):frequencyDivisions(2*k) ,:),1);
%     neuralNetInput_(5+k,:) = std(outputPhase(frequencyDivisions(2*k-1):frequencyDivisions(2*k) ,:),0,1);
% end

frequencyDivisions = [42 127];
for k=1:length(frequencyDivisions)/2
    neuralNetInputEye(k,:) = mean(outputPhase(frequencyDivisions(2*k-1):frequencyDivisions(2*k) ,:),1);
    neuralNetInputEye(length(frequencyDivisions)+k-1,:) = std(outputPhase(frequencyDivisions(2*k-1):frequencyDivisions(2*k) ,:),0,1);
end

channelsStreaming = streamingObj.propertyVector('channel');

triggerTimeStreaming = streamingObj.propertyVector('triggerTime');
indexPlot = 1:1:length(triggerTimeStreaming);

figure;
plot(triggerTimeStreaming(1:130), indexPlot(1:130),'.')
ylabel('Índice da Onda')
xlabel('Tempo de Captura (s)')

PACMATRIX = [RISETIME COUNT ABSENERGY DURATION RMS AMP ...
             ASL PCNTS RFRQ IFRQ CFRQ PFRQ FREQPP1 FREQPP2 FREQPP3 FREQPP4]';
         
  
%          ylabels = {'Tempo (s)', 'Count', 'Energy', 'Duration',...
%              'RMS', 'Amplitude', 'Average Signal Level', 'Counts To Peak', ...
%              'Reverb Frequency', 'Initi Frequency','Centroid Frequency',...
%              'Peak Frequency','FREQPP1','FREQPP1', 'FREQPP3', 'FREQPP4'};
         
STREAMINGMATRIX = double([streamingObj.propertyVector('riseTime')*1e6; ... 
                    streamingObj.propertyVector('count'); ... 
                    streamingObj.propertyVector('energy'); ... 
                    streamingObj.propertyVector('duration')*1e6; ... 
                    streamingObj.propertyVector('rms'); ... 
                    streamingObj.propertyVector('maxAmplitudeDB'); ... 
                    streamingObj.propertyVector('asl'); ... 
                    streamingObj.propertyVector('countToPeak'); ... 
                    streamingObj.propertyVector('reverberationFrequency'); ... 
                    streamingObj.propertyVector('initiationFrequency');]);
                
                STREAMINGMATRIX = STREAMINGMATRIX(:,1:130);
                STREAMINGMATRIX = [STREAMINGMATRIX;frequencyCentroid;...
                    peakFrequency;FREQPPMATRIX*100];
         
         rangePP = [1 39; 40 97; 98 136; 137 195]*1e3;

         
         FREQPPMATRIX = zeros(4,130);
         
         for l=1:130
             for k=1:4
                 deltaF = freqSlots > rangePP(k,1) & freqSlots < rangePP(k,2);

                 FREQPPMATRIX(k,l) = sum(outputAbs(l,deltaF(1:end-1)))/sum(outputAbs(l,:).^2);
             end
         end
         
                  
         meanFreqSlots =  0.5 * (freqSlots(1:end-1) + freqSlots(2:end));
        frequencyCentroid = meanFreqSlots * outputAbs'./(sum(outputAbs,2))';
        
        frequencyCentroid = frequencyCentroid/1e3;
         [~,I] = max(outputAbs,[], 2);
         peakFrequency = meanFreqSlots(I)/1e3;
         
         
 titles = {'Rise Time', 'Count', 'Energy', 'Duration',...
             'RMS', 'Amplitude DB', 'Average Signal Level', 'Counts To Peak', ...
             'Reverb Frequency', 'Initi Frequency','Centroid Frequency',...
             'Peak Frequency','FREQPP1','FREQPP2', 'FREQPP3', 'FREQPP4'};
         
         
         
         figure;
         
         for k=1:16
             subplot(2,1,1)
            h = histogram(STREAMINGMATRIX(k,:),200);
             title(titles{k})
             subplot(2,1,2)
             histogram(PACMATRIX(k,:),200)
             saveas(gcf,[titles{k} '_.png'])
         end
         
         triggertime = streamingObj.propertyVector('triggerTime');
         
         conf = []
         plotConfusionMatrix(conf, ['SP';'PE';'PI'])
          saveas(gcf,[ 'Confusion.png'])
          
          
          
          
          
          
          readCP4CicleOne
          [filesIndexes, sortIndexes] =sort(filesIndexes);
          folder = folder(sortIndexes);
          
          folder = folder(7:end);
          filesIndexes=filesIndexes(7:end);
                      fileBlock = fileBlock+200;

                      
                      [261, 320, 331, 365, 387, 458, 542, 543]
          handleFigBlock = figure;
          handleFigBlock_ = figure;
          for k=30:100
            fileBlock = (200+1+10*(k-1)):(200+10*k);
            compoundPath = [];
            for l=1:10
                compoundPath = [compoundPath; paths{folder(fileBlock(l))}];
            end
            
            verifyPressureBomb(fileBlock, [3], compoundPath, 'testeFAlta#',handleFigBlock)
            k
          end
          
rawData = readStreamingFile(['testeFAlta#' num2str(1191,'%03d') '.tdms'], 'J:\BACKUPJ\ProjetoPetrobras');


figure;
for k=1:16
    plot(rawData(:,k))
    title(num2str(k))
    pause
end