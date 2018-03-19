load('IDR02_04_wf1.mat')
load('IDR02_04_wf2.mat')
vallenCP4 = double([IDR02_04_wf1 IDR02_04_wf2]);
vallenCP4 = (10/(2^13*4))* vallenCP4;

figure;
plot(max(vallenCP4))
ylabel('Amplitude Maxima')
title('Sinal Completo (2 ciclos')
hold on;
grid on;
plot([size(IDR02_04_wf1,2) size(IDR02_04_wf1,2)],[0 max(max(vallenCP4))],'k--')

figure;
plot(max(IDR02_04_wf1))
grid on;

ylabel('Amplitude Maxima')
title('Primeiro Ciclo')

figure;
plot(max(IDR02_04_wf2))
grid on;

ylabel('Amplitude Maxima')
title('Segundo Ciclo')


ah = findobj('Type','figure'); % get all figures
for m=1:numel(ah) % go over all axes
  set(findall(ah(m),'-property','FontSize'),'FontSize',13)
  set(ah(m),'color','w')
   axes_handle = findobj(ah(m),'type','axes');
   ylabel_handle = get(axes_handle,'ylabel');
   title_handle = get(axes_handle,'title');
   
  saveas(ah(m),[title_handle.String '.png'])
end


separationIndexes.indexSP = 2.4e4;
separationIndexes.indexPI = 4.5e4;
timeWindow = 2^14;
% PIRemainsIndex = 47240; % correct value
PIRemainsIndex = 4.62e4; %
normalized = 1;
visible = 'Off';
visibleNormalized = 'On';
visiblePhase = 'Off';
frequencyDivisions = [];
method = 'MLP';
minAcceptableAmplitude = 0.0e-4; 


mainVallenCP4 = loadData('IDR02_04_wf2.mat', timeWindow, ...
    minAcceptableAmplitude, separationIndexes,PIRemainsIndex);

vallenFigureHandles = plotData(mainVallenCP4);

corrInputClasses = correlationAnalysis(mainVallenCP4);

energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses,mainVallenCP4.frequencyVector, normalized, visibleNormalized);

[~, frequencyDivisions, indexFrequencyDivisions] = generateInput(...
    mainVallenCP4.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallenCP4.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.PI(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallenCP4.frequencyVector);



neuralNetInputMean = mean(neuralNetInput,2);
neuralNetInputStd = std(neuralNetInput,0,2);

for k = 1:size(neuralNetInput,1)
    neuralNetInput(k,:) = (neuralNetInput(k,:) - neuralNetInputMean(k))/neuralNetInputStd(k);
end

trainedModel = mainTrain(neuralNetInput(:,1:45000),...
    mainVallenCP4.sparseCodification(1:2,1:45000), method, mainVallenCP4.separationIndexes);

separationIndexesCP4 = mainVallenCP4.separationIndexes;

numDivisions = 100;
numStops = separationIndexesCP4.timePI/numDivisions;
target = zeros(2,45000);
meanOutputConfusion = zeros(2,2,numDivisions-1);
stdOutputConfusion = zeros(2,2,numDivisions-1);

for k = 1:numDivisions-1
   
    separationIndexesCP4.timeSP = numStops*k;
    
    target(1,:) = [ones(1,separationIndexesCP4.timeSP) zeros(1,45000 - separationIndexesCP4.timeSP)];
    target(2,:) = 1*(~target(1,:));
    
trainedModel = mainTrain(neuralNetInput(:,1:45000),...
    target, method, separationIndexesCP4);
    
meanOutputConfusion(:,:,k) = mean(trainedModel.confusionMatrix.test,3);
stdOutputConfusion(:,:,k) = std(trainedModel.confusionMatrix.test,0,3);
end


normalizedMeanConfusion = meanOutputConfusion;
normalizedStdConfusion = stdOutputConfusion;

for k =1:size(normalizedStdConfusion,3)
    normalizedMeanConfusion(1,:,k) = normalizedMeanConfusion(1,:,k)/sum(normalizedMeanConfusion(1,:,k));
    normalizedMeanConfusion(2,:,k) = normalizedMeanConfusion(2,:,k)/sum(normalizedMeanConfusion(2,:,k));
  
    normalizedStdConfusion(1,:,k) = normalizedStdConfusion(1,:,k)/sum(normalizedStdConfusion(1,:,k));
    normalizedStdConfusion(2,:,k) = normalizedStdConfusion(2,:,k)/sum(normalizedStdConfusion(2,:,k)); 
end


figure;

plot(450*(1:length(normalizedMeanConfusion(1,1,:))),...
    reshape(normalizedMeanConfusion(1,1,:),1,length(normalizedMeanConfusion(1,1,:))),'r.')
hold on
plot(450*(1:length(normalizedMeanConfusion(2,2,:))),...
    reshape(normalizedMeanConfusion(2,2,:),1,length(normalizedMeanConfusion(2,2,:))),'k.')
grid on
legend('SP','PE')
xlabel('Indice de Divisao')
ylabel('Acerto')
title('Test')



figure;
plot(450*(1:length(normalizedMeanConfusion(1,2,:))),...
    reshape(normalizedMeanConfusion(1,2,:),1,length(normalizedMeanConfusion(1,2,:))),'r.')
hold on

plot(450*(1:length(normalizedMeanConfusion(2,1,:))),...
    reshape(normalizedMeanConfusion(2,1,:),1,length(normalizedMeanConfusion(2,1,:))),'k.')




% trainedModel = mainTrain(neuralNetInput, mainVallen.sparseCodification, method, mainVallen.separationIndexes);

% frequencyDivisions = mainVallenCP4.frequencyVector(diff(indexFrequencyDivisions) ~= 0);

[neuralNetInputCP2, frequencyDivisionsCP2, indexFrequencyDivisionsCP2] = generateInput(...
    mainVallen.normalizedEnergy, ...
    frequencyDivisions, ...
    energyCrossCorrFigHandles.normalizedEnergy, ...
    mainVallen.frequencyVector(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    corrInputClasses.normalizedEnergy.PI(find(corrInputClasses.gIndexesNormalizedEnergy)),...
    mainVallen.frequencyVector);

best_separationIndexesCP4.timeSP = 21600;
best_separationIndexesCP4.timePI= 45000;

    target(1,:) = [ones(1,21600) zeros(1,45000 - 21600)];
    target(2,:) = 1*(~target(1,:));
    
trainedModelCP4 = mainTrain(neuralNetInput(:,1:45000),...
    target, method, best_separationIndexesCP4);


classifierCP4 = trainedModelCP4.outputRuns(6).net;

    targetsCP2(1,:) = [ones(1,224) zeros(1,425 - 425)];
    targetsCP2(2,:) = 1*(~targetsCP2(1,:));
    
    
for k = 1:size(neuralNetInput,1)
    neuralNetInputCP2(k,:) = (neuralNetInputCP2(k,:) - mean(neuralNetInputCP2(k,:)))/std(neuralNetInputCP2(k,:));
end
    
    classifierOutput = classifierCP4(neuralNetInputCP2(:,1:300)) > 0.5;
    
    classifierOutput = 1*classifierOutput;
    classifierOutput(1,:) = 1*classifierOutput(1,:);
    classifierOutput(2,:) = 2*classifierOutput(2,:);
    classifierOutput = sum(classifierOutput,1);
    
    targetsConfusion = ones(1,300);
    targetsConfusion(224:300) = 2;
    
    C = confusionmat(targetsConfusion, classifierOutput)


    Cp = C;
    Cp(1,:) =  Cp(1,:)/sum( Cp(1,:));
    Cp(2,:) =  Cp(2,:)/sum( Cp(2,:))

    
    finalConfusionCP4 = trainedModelCP4.confusionMatrix.test;
    
    for k=1:size(finalConfusionCP4,3)
        
        finalConfusionCP4(1,:,k) = finalConfusionCP4(1,:,k)/sum(finalConfusionCP4(1,:,k));
        finalConfusionCP4(2,:,k) = finalConfusionCP4(2,:,k)/sum(finalConfusionCP4(2,:,k));
    end
    
    finalConfusionMeanCP4 = mean(finalConfusionCP4,3)
    finalConfusionStdCP4 = std(finalConfusionCP4,0,3)
