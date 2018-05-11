 load('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\streamingOBJ\streamingOBJCP3_Ciclo_1.mat')
load('frequencyDivisions.mat')

rawDataCell = streamingObj.propertyVector('rawData');

fields = fieldnames(streamingObj.Waves);
freqSlots = linspace(0, 1.25e6, 2^11);
partialFrequencyVector = zeros(1,2^12-1);

rawDataCell(131:end) = [];

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


[neuralNetInputPhase, ~, indexFrequencyDivisions_] = generateInput(...
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
inputMatrix = zeros(length(variables),468);

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

inputMatrix(:,131:end) = [];


mainVallen4Classes = mainVallen;
% trainedModelWithPhase = trainedModel__;
fourthClass = zeros(1,length(inputMatrix));
% weirdIndexes = [37:39, 27, 29, 9, 72, 78, 79, 90,92,95,97,100,103,102,104,105];
weirdIndexes = [2,7,27 36 37 44 72 66 81 105 110:114];
fourthClass(weirdIndexes) = 1;
mainVallen4Classes.sparseCodification(:, weirdIndexes) = 0;
mainVallen4Classes.sparseCodification = [mainVallen4Classes.sparseCodification;fourthClass];


neuralNetInput(:,weirdIndexes) = [];
mainVallen.sparseCodification(:,weirdIndexes) = [];
inputMatrix(:, weirdIndexes) = [];

mainVallen.separationIndexes.timePI = mainVallen.separationIndexes.timePI-15;
mainVallen.separationIndexes.timeSP = mainVallen.separationIndexes.timeSP-9;

% neuralNetInput(:,channel8Indexes) = [];
% mainVallen.sparseCodification(:, channel8Indexes) = [];
% inputMatrix(:, channel8Indexes) = [];

trainedModelWeirdIndexes4Classes = mainTrain...
    ([inputMatrix;neuralNetInput(1:5,:)],...
    mainVallen4Classes.sparseCodification, method, mainVallen4Classes.separationIndexes);


trainedModelWithoutPhase_ = mainTrain...
    ([inputMatrix;neuralNetInput(1:5,:)], mainVallen.sparseCodification, method, mainVallen.separationIndexes);


totalOutput =[];
for k=1:35
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
100*std(trainedModelWithoutPhase.confusionMatrix.percentValidation,[], 3)


100*mean(trainedModelWithPhase.confusionMatrix.percentValidation, 3)

modelPlotFigureHandle = plotModel(trainedModel);



figure
for k=1:length(weirdIndexes)
    tempo = 0:1:length(streamingObj.Waves(weirdIndexes(k)).rawData)-1;
    tempo = tempo/(2.5e6);
    plot(tempo, streamingObj.Waves(weirdIndexes(k)).rawData,'-')
    xlabel('Tempo (s)')
    ylabel('Amplitude')
    title(num2str(weirdIndexes(k)))
    savefig([num2str(weirdIndexes(k))])
    
end


vetor1 = [0.1 0.2 0.3 -0.1 -0.5 0.5 0.2 -0.9 1 0.07 0.7 0.5 -0.11 -0.01 0.2];
vetor2 = vetor1(randperm(length(vetor1))
figure
subplot(2,1,1)
plot(vetor1)
subplot(2,1,2)
plot(vetor2)
indexesSignal = find(vetor1.*vetor2 < 0); 
hold on
plot(indexesSignal, vetor2(indexesSignal))
vetor1
