separationIndexes.indexSP = 897;
separationIndexes.indexPI = 1300;
timeWindow = 2^14;
minAcceptableAmplitude = 3.5e-4;
PIRemainsIndex = 1492;
normalized = 2;
visible = 'Off';
visibleNormalized = 'On';
visiblePhase = 'Off';
frequencyDivisions = [];
method = 'MLP';

mainVallen = loadData('Idr02_02_ciclo1_1.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes,PIRemainsIndex);

% vallenFigureHandles = plotData(mainVallen);

corrInputClasses = correlationAnalysis(mainVallen);

% energyDirectCorrFigHandles = plotDirectCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visible);
% phaseCorrFigHandles = plotPhaseCorr(corrInputClasses,mainVallen.frequencyVector, visiblePhase);

energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses,mainVallen.frequencyVector, normalized, visibleNormalized);
[neuralNetInput, frequencyDivisions] = generateInput(...
    mainVallen.normalizedEnergy, frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, mainVallen.frequencyVector);


trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method);

% ah = findobj('Type','figure'); % get all figures
% for m=1:numel(ah) % go over all axes
%   set(findall(ah(m),'-property','FontSize'),'FontSize',16)
%    axes_handle = findobj(ah(m),'type','axes');
%    ylabel_handle = get(axes_handle,'ylabel');
%    set(ah(m),'Color','w')
%   % saveas(ah(m),[ylabel_handle.String num2str(m) '.png'])
% end