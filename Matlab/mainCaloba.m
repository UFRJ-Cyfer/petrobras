separationIndexes.indexSP = 897;
separationIndexes.indexPI = 1300;
timeWindow = 2^14;
PIRemainsIndex = 1492;
normalized = 1;
visible = 'Off';
visibleNormalized = 'On';
visiblePhase = 'Off';
frequencyDivisions = [];
method = 'MLP';
minAcceptableAmplitude = 4.0e-4; 



mainVallen = loadData('Idr02_02_ciclo1_1.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes,PIRemainsIndex);

vallenFigureHandles = plotData(mainVallen);

corrInputClasses = correlationAnalysis(mainVallen);

% energyDirectCorrFigHandles = plotDirectCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visible);
% phaseCorrFigHandles = plotPhaseCorr(corrInputClasses,mainVallen.frequencyVector, visiblePhase);

energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visibleNormalized);

[neuralNetInput, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
    mainVallen.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.PI(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);


trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method);

neuralNetOutput = mainVallen.sparseCodification;
neuralNetRawInput = mainVallen.fftDataRaw;
% modelPlotFigureHandle = plotModel(trainedModel);


save('\BitBucket\ProjetoPetrobras\Matlab\Data\neuralNetData.mat','neuralNetInput','neuralNetOutput','neuralNetRawInput');


