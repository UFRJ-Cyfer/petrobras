%  load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\streamingOBJ\streamingOBJCP3_Ciclo_1.mat')
load('frequencyDivisions.mat')

rawDataCell = streamingObj.propertyVector('rawData');

fields = fieldnames(streamingObj.Waves);
freqSlots = linspace(0, 1.25e6, 2^11);
partialFrequencyVector = zeros(1,2^12-1);
fftWaves = {};
% LASTINDEX = 306;
% rawDataCell(LASTINDEX:end) = [];
% rawDataCell(212) = [];


for k=1:length(rawDataCell)
    wave = double(rawDataCell{k});
    wave = wave(1:end-2500);
    wave = wave - mean(wave);
    fftWave = fft(wave)/length(wave);
%    there is no problem multiplying by 2 here since H(0) = 0
    fftWave = 2*fftWave(1:(length(wave) - mod(length(wave),2))/2);
   fftWaves{k} = fftWave;
end

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

[mainVallen] = streamVariableSizeToVallenFormat(streamingObj, outputAbs', outputPhase');
corrInputClasses = correlationAnalysis(mainVallen);

visibleNormalized = 1;
normalized = 2;
visible = 'on';

energyCrossCorrFigHandles = ...
    plotCrossCorr(corrInputClasses,mainVallen.frequencyVector,...
    normalized, visible);

vallenFigureHandles = plotData(mainVallen);


fc = 1e4;
fs = 2.5e6;

[b,a] = butter(6,fc/(fs/2));
phase = filter(b,a,mainVallen.phase);

frequencyDivisions = [];

[neuralNetInputPhase, frequencyDivisions, indexFrequencyDivisions_] = generateInput(...
    phase, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.mergedClasses(:,find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);

[neuralNetInput, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
    mainVallen.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.mergedClasses(:,find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);


for k=1:length(streamingObj.Waves)
    streamingObj.Waves(k) = streamingObj.Waves(k).calculateParameters(2.5e6, streamingObj);
end



method = 'MLP'
variables = [3:6 8 9 11 13 15 16]; %14,12 
inputMatrix = zeros(length(variables),length(streamingObj.Waves));

% [3:7 9:11 13:16 18]
% [3:7 9:11 13 15 17 18]
indexMatrix = 1;
for k=variables
    inputMatrix(indexMatrix,:) = [streamingObj.Waves.(fields{k})];
    indexMatrix = indexMatrix+1;
end

for k=variables
   fields{k} 
end
% 
% inputMatrix(:,LASTINDEX:end) = [];
% inputMatrix(:,212) = [];

% mainVallen4Classes = mainVallen;
% % trainedModelWithPhase = trainedModel__;
% fourthClass = zeros(1,length(inputMatrix));
% % weirdIndexes = [37:39, 27, 29, 9, 72, 78, 79, 90,92,95,97,100,103,102,104,105];
% weirdIndexes = [2,7,27 36 37 44 72 66 81 105 110:114];
% fourthClass(weirdIndexes) = 1;
% mainVallen4Classes.sparseCodification(:, weirdIndexes) = 0;
% mainVallen4Classes.sparseCodification = [mainVallen4Classes.sparseCodification;fourthClass];
% 
% 
% neuralNetInput(:,weirdIndexes) = [];
% mainVallen.sparseCodification(:,weirdIndexes) = [];
% inputMatrix(:, weirdIndexes) = [];
% 
% mainVallen.separationIndexes.timePI = mainVallen.separationIndexes.timePI-15;
% mainVallen.separationIndexes.timeSP = mainVallen.separationIndexes.timeSP-9;

% neuralNetInput(:,channel8Indexes) = [];
% mainVallen.sparseCodification(:, channel8Indexes) = [];
% inputMatrix(:, channel8Indexes) = [];
% 

% trainedModelWeirdIndexes4Classes = mainTrain...
%     ([inputMatrix;neuralNetInput(1:5,:)],...
%     mainVallen4Classes.sparseCodification, method, mainVallen4Classes.separationIndexes);
% mainVallen.sparseCodification(1,183:214) = 1;
% mainVallen.sparseCodification(2,183:214) = 0;

trainedModelWithoutPhase_ = mainTrain...
    ([inputMatrix;neuralNetInput(1:size(neuralNetInput,1)/2,:)], mainVallen.sparseCodification, method, mainVallen.separationIndexes);


totalOutput(totalOutput>=0.5) = 1; 
totalOutput(totalOutput<0.5) = 0; 

mainVallen.sparseCodification = totalOutput;
totalOutput(2,[255]) = 1;


totalOutput =[];

for k=1:100
totalOutput(:,:,k)= trainedModelWithoutPhase_.outputRuns(k).filteredOutput;
end

figure;
totalOutput = mean(totalOutput,3);

rgb = reshape(totalOutput', 1, size(totalOutput,2), 3);
imagesc(rgb)

% matrix2latex(100*mean(trainedModel.confusionMatrix.percentValidation,[], 3),'confstd.tex', 'alignment','c','columnLabels',{'SP', 'PE', 'PI'}, 'rowLabels',{'SP', 'PE', 'PI'}, 'format', '%.2f' )

aux = sum(trainedModelWithoutPhase.confusionMatrix.validation, 3);
accuracyScore = trace(aux)/sum(sum(aux))

sum(trainedModelWeirdIndexes4Classes.confusionMatrix.validation, 3)
100*mean(trainedModelWithoutPhase_.confusionMatrix.percentValidation, 3)
100*std(trainedModelWithoutPhase_.confusionMatrix.percentValidation,[], 3)


100*mean(trainedModelWithPhase.confusionMatrix.percentValidation, 3)

modelPlotFigureHandle = plotModel(trainedModelWithoutPhase_);

% 
% 
% figure
% for k=1:length(weirdIndexes)
%     tempo = 0:1:length(streamingObj.Waves(weirdIndexes(k)).rawData)-1;
%     tempo = tempo/(2.5e6);
%     plot(tempo, streamingObj.Waves(weirdIndexes(k)).rawData,'-')
%     xlabel('Tempo (s)')
%     ylabel('Amplitude')
%     title(num2str(weirdIndexes(k)))
%     savefig([num2str(weirdIndexes(k))])
%     
% end
figure
for k=1:668
    plot(streamingObj.Waves(k).rawData);
    title(num2str(k))
    pause;
    
    
end
