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
title('E Média SP ')
ylabel('Energia')
xlabel('Frequência (Hz)')

figEnergyPE = figure; plot(mainVallen.frequencyVector,meanEnergyPE)
grid on
title('E Média PE ')
ylabel('Energia')
xlabel('Frequência (Hz)')

figEnergyPI = figure; plot(mainVallen.frequencyVector,meanEnergyPI)
grid on
title('E Média PI ')
ylabel('Energia')
xlabel('Frequência (Hz)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figNormalizedEnergySP = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergySP)
grid on
title('E Normalizada Média SP')
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')

figNormalizedEnergyPE = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergyPE)
grid on
title('E Normalizada Média PE')
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')

figNormalizedEnergyPI = figure; plot(mainVallen.frequencyVector,meanNormalizedEnergyPI)
grid on
title('E Normalizada Média PI')
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')


%%%%%%%%%%%%%%%%%%%PHASE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = 1e4;
fs = 2.5e6;

[b,a] = butter(6,fc/(fs/2));
phase = filter(b,a,mainVallen.phase);

meanPhaseSP = mean(phase(:,1:time_sp),2);
meanPhasePE = mean(phase(:,time_sp:time_pi),2);
meanPhasePI = mean(phase(:,time_pi:end),2);


figNormalizedPhaseSP = figure; plot(mainVallen.frequencyVector,meanPhaseSP)
hold on;
plot(mainVallen.frequencyVector,meanPhasePE)
grid on
title('Fase SP')
ylabel('Fase (rad) ')
xlabel('Frequência (Hz)')

figNormalizedPhasePE = figure; plot(mainVallen.frequencyVector,meanPhasePE)
grid on
title('Fase PE')
ylabel('Fase (rad)')
xlabel('Frequência (Hz)')

figNormalizedPhasePI = figure; plot(mainVallen.frequencyVector,meanPhasePI)
grid on
title('Fase PI')
ylabel('Fase (rad)')
xlabel('Frequência (Hz)')

% figureHandles.figEnergySP = figEnergySP;
% figureHandles.figEnergyPE = figEnergyPE;
% figureHandles.figEnergyPI = figEnergyPI;

figureHandles.figNormalizedEnergySP = figNormalizedEnergySP;
figureHandles.figNormalizedEnergyPE = figNormalizedEnergyPE;
figureHandles.figNormalizedEnergyPI = figNormalizedEnergyPI;


end