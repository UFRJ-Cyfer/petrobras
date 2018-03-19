figure;
plot(mean(mainVallen.timeDataRaw(:,2),2))

figure;
plot(cp4Data(:,1))

figure;
plot(1/fs*(1:42500),(10/(2^13*4))*mean(streamingStruct(4).rawData(:,1:1009),2));
xlabel('Tempo (s)');
figure;
plot(1/fs*(1:8000),(10/(2^13*4))*mean(streamingStruct(4).rawData(1:8000,1010:1342),2));
xlabel('Tempo (s)');
figure;
plot((10/(2^13*4))*mean(streamingStruct(4).rawData(1:10000,1342:end),2));
xlabel('Tempo (s)');


separationIndexes.indexSP = 1009;
separationIndexes.indexPI = 1342;



startingTimeCP3 = streamingStruct(3).startingTime;

startingTimeCP4 = streamingStruct(4).startingTime;

channelsCP3 = streamingStruct(3).channel;
channelsCP4 = streamingStruct(4).channel;

timePI = 8000;
timeSP = 4000;


separationIndexes.indexSP = 1009;
separationIndexes.indexPI = 1342;
timeWindow = 2^14;
PIRemainsIndex = 7600;
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


mainVallen = loadData('Idr02_04_wf2.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes, 1516, fs, streamingStruct(4).rawData);

% textStruct = textFileAnalyser('Idr02_04_c2.txt',0);

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




for k=1:16
    subplot(4,4,k)
    histogram(diff(streamingStruct(4).startingTime(streamingStruct(4).channel == k)),0:0.01:1.1)
    title(['channel ' num2str(k)])
    if k>=13
        xlabel('\Delta T (s)','interpreter','tex');
    end
end


