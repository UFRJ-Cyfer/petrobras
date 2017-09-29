% separationIndexes.indexSP = 1400;
% separationIndexes.indexPI = 4900;

separationIndexes.indexSP = 973;
separationIndexes.indexPI = 1341;
timeWindow = 2^14;
PIRemainsIndex = 1516;
normalized = 1;
fs = 2.5e6;
visible = 'Off';
visibleNormalized = 'On';
visiblePhase = 'Off';
frequencyDivisions = [];
method = 'MLP';
minAcceptableAmplitude = 0; 

% frequencyDivisions = 1e5*[0.31 0.49 0.49 0.61 0.61 0.67];
frequencyDivisions = [];

cp4Data = streamingStruct(4).rawData;

mainVallen = loadData('Idr02_04_wf2.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes,PIRemainsIndex,fs,cp4Data);

textStruct = textFileAnalyser('Idr02_04_c2.txt',0);
channelsWithWaves = textStruct.channels(~isnan(textStruct.waveIndexes));

IDR02_04_wf2 = IDR02_04_wf2(:,channelsWithWaves ~= 6);


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
    corrInputClasses.normalizedEnergy.PI(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);


neuralNetInput = [neuralNetInput; log10(mainVallen.totalEnergy)];


trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method, mainVallen.separationIndexes);



neuralNetOutput = mainVallen.sparseCodification;
neuralNetRawInput = mainVallen.fftDataRaw;

modelPlotFigureHandle = plotModel(trainedModel);

save('.\Matlab\Data\mainDataAmplitude40.mat','mainVallen','trainedModel','frequencyDivisions');

