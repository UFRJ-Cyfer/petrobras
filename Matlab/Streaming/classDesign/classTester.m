% % wave1 = Wave;
% % wave2 = Wave;
% % 
% % wave1.duration = 1;
% % wave2.duration = 2;
% % 
% % strClass = StreamingClass;
% % 
% % strClass = strClass.addWave(wave1);
% % strClass = strClass.addWave(wave2);
% % 
% % sum([strClass.Waves.duration])
% % 
% % 
% % 
% % rawData = readStreamingFile( filename, paths{k} );
% 
% streamingObj = StreamingClass();
% 
% streamingObj.hdt = 1000e-6;
% streamingObj.hlt = 1000e-6;
% streamingObj.pdt = 800e-6;
% 
% noiseLevel = zeros(1,12);
% noiseLevel(7) = 100;
% 
% lastIndexArray = ones(1,12);
% lastIndexArray = lastIndexArray * ceil(2.5e6*1e-3) * -1;
% 
% rawData = readStreamingFile( filename, path );
% %  [ rawDataClean, noiseLevel, slots] = removeTOFD( rawData, 12 );
% 
% 
% [streamingObj lastIndexArray] = streamingObj.identifyWaves(rawData(1:end,:), [7 12], 2.5e6, ...
%     noiseLevel, 272, lastIndexArray);
% % 
%  triggerArray = streamingObj.propertyVector('triggerTime');
%  durationV = streamingObj.propertyVector('duration');
%  
%  figure
%  plot(rawDataClean(:,12))
%  hold on;
%  plot(triggerArray, 400*ones(size(triggerArray)),'.')
% 
%  resolutionArray = streamingObj.propertyVector('resolution');
%  rawDataCell = streamingObj.propertyVector('rawData');
%  
%  rawDataCell(131:end) = [];
%  
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
%     there is no problem multiplying by 2 here since H(0) = 0
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
% 
% 
%  triggerArray = streamingObj.propertyVector('triggerTime');
%  amplitudeArray = streamingObj.propertyVector('maxAmplitude');
%  
%  triggerArray(131:end) = [];
%  
%  
%  timePE = 3000;
%  timePI = 9000;
%  
%  slotsSP = triggerArray < timePE;
%  slotsPE = triggerArray >= timePE & triggerArray < timePI;
%  slotsPI = triggerArray >= timePI;
%  
%  outputAbsolute = abs(output);
%  normalizedAbsolute = outputAbsolute./repmat(sum(outputAbsolute,2), 1, size(outputAbsolute,2));
%  
%  lastIndex = 1e3;
%  figure;
%  plot(freqSlots(1:lastIndex),mean(normalizedAbsolute(slotsSP,1:lastIndex),1))
%  hold on;
%  plot(freqSlots(1:lastIndex), mean(normalizedAbsolute(slotsPE,1:lastIndex),1))
%  plot(freqSlots(1:lastIndex),mean(normalizedAbsolute(slotsPI,1:lastIndex),1))
% legend('SP','PE','PI')
% 
% 
% 
% output(isnan(output)) = 0;
% 
% 
% 
% [mainVallen] = streamVariableSizeToVallenFormat(streamingObj, outputAbsolute');
% 
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
% 
% 
[neuralNetInput, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
    mainVallen.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.mergedClasses(:,find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);
% 
method = 'MLP'
trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method, mainVallen.separationIndexes);
modelPlotFigureHandle = plotModel(trainedModel);
% 
% wavesRaw = {}





figure
subplot(2,1,1)
title('Variavel')
tt = propertyVector( streamingObj, 'triggerTime' );
plot(tt, linspace(1,length(tt), length(tt)),'.')


subplot(2,1,2)
title('Fixo')
plot(triggerTime, linspace(1,length(triggerTime),length(triggerTime)),'.')
