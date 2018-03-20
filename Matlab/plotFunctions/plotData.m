function figureHandles = plotData(mainVallen)

%PLOTDATA Plots both energy and normalized energy separated by classes


time_sp = mainVallen.separationIndexes.timeSP;
time_pi = mainVallen.separationIndexes.timePI;

meanEnergySP = mean(mainVallen.energy(:,1:time_sp),2);
meanEnergyPE = mean(mainVallen.energy(:,time_sp:time_pi),2);
meanEnergyPI = mean(mainVallen.energy(:,time_pi:end),2);

meanNormalizedEnergySP = mean(mainVallen.normalizedEnergy(:,1:time_sp),2);
meanNormalizedEnergyPE = mean(mainVallen.normalizedEnergy(:,time_sp:time_pi),2);
meanNormalizedEnergyPI = mean(mainVallen.normalizedEnergy(:,time_pi:end),2);


figEnergySP = figure; plot(mainVallen.frequencyVector,meanEnergySP)
grid on
title('E M�dia SP ')
ylabel('Energia')
xlabel('Frequ�ncia (Hz)')

figEnergyPE = figure; plot(mainVallen.frequencyVector,meanEnergyPE)
grid on
title('E M�dia PE ')
ylabel('Energia')
xlabel('Frequ�ncia (Hz)')

figEnergyPI = figure; plot(mainVallen.frequencyVector,meanEnergyPI)
grid on
title('E M�dia PI ')
ylabel('Energia')
xlabel('Frequ�ncia (Hz)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figNormalizedEnergySP = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergySP)
grid on
title('E Normalizada M�dia SP')
ylabel('Energia Normalizada')
xlabel('Frequ�ncia (Hz)')

figNormalizedEnergyPE = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergyPE)
grid on
title('E Normalizada M�dia PE')
ylabel('Energia Normalizada')
xlabel('Frequ�ncia (Hz)')

figNormalizedEnergyPI = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergyPI)
grid on
title('E Normalizada M�dia PI')
ylabel('Energia Normalizada')
xlabel('Frequ�ncia (Hz)')


% figureHandles.figEnergySP = figEnergySP;
% figureHandles.figEnergyPE = figEnergyPE;
% figureHandles.figEnergyPI = figEnergyPI;

figureHandles.figNormalizedEnergySP = figNormalizedEnergySP;
figureHandles.figNormalizedEnergyPE = figNormalizedEnergyPE;
figureHandles.figNormalizedEnergyPI = figNormalizedEnergyPI;


end