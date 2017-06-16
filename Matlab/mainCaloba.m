
separationIndexes.indexSP = 897;
separationIndexes.indexPI = 1300;
timeWindow = 2^14;
minAcceptableAmplitude = 3.5e-4;
PIRemainsIndex = 1492;
normalized = 2;

mainVallen = loadData('Idr02_02_ciclo1_1.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes,PIRemainsIndex);

vallenFigureHandles = plotData(mainVallen);

corrInputClasses = correlationAnalysis(mainVallen);

corrFigureHandles = plotCorr(corrInputClasses);

generateInput();

energyDirectCorrFigHandles = plotDirectCorr(corrInputClasses,mainVallen.frequencyVector, normalized);
energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses,mainVallen.frequencyVector, normalized);
phaseCorrFigHandles = plotPhaseCorr(corrInputClasses,mainVallen.frequencyVector);

% ah = findobj('Type','figure'); % get all figures
% for m=1:numel(ah) % go over all axes
%   set(findall(ah(m),'-property','FontSize'),'FontSize',16)
%    axes_handle = findobj(ah(m),'type','axes');
%    ylabel_handle = get(axes_handle,'ylabel');
%    set(ah(m),'Color','w')
%   % saveas(ah(m),[ylabel_handle.String num2str(m) '.png'])
% end