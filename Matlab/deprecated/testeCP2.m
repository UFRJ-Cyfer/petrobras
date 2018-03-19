separationIndexesCP2 = mainVallen.separationIndexes;
numDivisions = 20;
sampleSize = size(neuralNetInput,2);
numStops = separationIndexesCP2.timePI/numDivisions;
target = zeros(2,separationIndexesCP2.timePI);
meanOutputConfusion = zeros(2,2,numDivisions-1);
stdOutputConfusion = zeros(2,2,numDivisions-1);
timeModifiedCP2 = zeros(1,numDivisions-1);

for k = 1:numDivisions-1
   
    separationIndexesCP2.timeSP = numStops*k;
    timeModifiedCP2(k) = textStruct.timeVectorCaptured(separationIndexesCP2.timeSP);
    
    
    target(1,:) = [ones(1,separationIndexesCP2.timeSP) zeros(1,separationIndexesCP2.timePI - separationIndexesCP2.timeSP)];
    target(2,:) = 1*(~target(1,:));
    
trainedModel = mainTrain(neuralNetInput(:,1:separationIndexesCP2.timePI),...
    target, method, separationIndexesCP2);
    
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

plot(1500+timeModifiedCP2,...
    reshape(normalizedMeanConfusion(1,1,:),1,length(normalizedMeanConfusion(1,1,:))),'r.')
hold on
plot(1500+timeModifiedCP2,...
    reshape(normalizedMeanConfusion(2,2,:),1,length(normalizedMeanConfusion(2,2,:))),'k.')
grid on
legend('SP','PE')
xlabel('Tempo (s)')
ylabel('Acerto')
axis([0 9000 0 1])



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
