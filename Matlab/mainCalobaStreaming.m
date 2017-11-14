% [ streamingStructCleaned, structDT, tofdIndexes ] = removeTOFD( streamingStructMain );
% 

for k=3
timeWindow = 2^14;
% PIRemainsIndex = 1516;
normalized = 1;
fs = 2.5e6;
visible = 'Off';
visibleNormalized = 'On';
visiblePhase = 'Off';
method = 'MLP';
minAcceptableAmplitude = 0; 

% frequencyDivisions = 1e5*[0.31 0.49 0.49 0.61 0.61 0.67];
frequencyDivisions = streamingStructCleaned(k).frequencyDivisions;

[mainVallen] = streamRawDataToVallenFormat(streamingStructCleaned(k).rawData, separationIndexes);

vallenFigureHandles_ = plotData(mainVallen);

corrInputClasses = correlationAnalysis(mainVallen);

% energyDirectCorrFigHandles = plotDirectCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visible);
% phaseCorrFigHandles = plotPhaseCorr(corrInputClasses,mainVallen.frequencyVector, visiblePhase);

energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visibleNormalized);

[neuralNetInput, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
    mainVallen.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.mergedClasses(:,find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);

streamingStructCleaned(k).frequencyDivisions = frequencyDivisions;

% neuralNetInput = [neuralNetInput; log10(mainVallen.totalEnergy)];


trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method, mainVallen.separationIndexes);

neuralNetOutput = mainVallen.sparseCodification;
% neuralNetRawInput = mainVallen.fftDataRaw;

modelPlotFigureHandle = plotModel(trainedModel);

save(['.\Matlab\Data\neuralNetData' streamingStructCleaned(k).description '.mat'],'mainVallen','trainedModel','frequencyDivisions');
end