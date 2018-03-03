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
% output = zeros(length(fftWaves),2^11-1);
% for k=1:length(fftWaves)
%     freq = linspace(0,1.25e6, length(fftWaves{k}));
%     waveFFT = fftWaves{k};
%     for l=1:(length(freqSlots)-1)
%        boola = (freq >= freqSlots(l)) & (freq < freqSlots(l+1));
%        fftVector = mean(waveFFT(boola));
%        output(k, l) = fftVector;
%     end
%     k
% end
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
% [mainVallen] = streamVariableSizeToVallenFormat(streamingObj, outputAbsolute');
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

fields = fieldnames(streamingObj.Waves);

indexMatrix = 1;
inputMatrix = zeros(13,468);

for k=[3:7 9:11 13:16 18]
   
    inputMatrix(indexMatrix,:) = [streamingObj.Waves.(fields{k})];
    indexMatrix=  indexMatrix+1;
end

inputMatrix(:,131:end) = [];

trainedModel_ = mainTrain...
    (inputMatrix, mainVallen.sparseCodification, method, mainVallen.separationIndexes);

