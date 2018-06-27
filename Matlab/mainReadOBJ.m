sOBJ2 = StreamingClass('CP2')
sOBJ3 = StreamingClass('CP3')
sOBJ4 = StreamingClass('CP4')
sOBJ2.readStreaming()
SOBJ3 = sOBJ3.readStreaming(1,1420);
sOBJ4.readStreaming();



CP2.cycleDividers = [201 246];
CP4.cycleDividers = [318];

CP2 = CP2.adjustCycles();
CP4 = CP4.adjustCycles();

CP2 = CP2.createFrequencyData(2.5e6);
CP4 = CP4.createFrequencyData(2.5e6);
CP3 = CP3.createFrequencyData(2.5e6);

CP2 = CP2.divideClasses();
CP4 = CP4.divideClasses();
CP3 = CP3.divideClasses();

CP2.StreamingModel = CP2.StreamingModel.corrAnalysis(CP2.normalizedPower, 'normalizedPower');
CP4.StreamingModel = CP4.StreamingModel.corrAnalysis(CP4.normalizedPower, 'normalizedPower');
CP3.StreamingModel = CP3.StreamingModel.corrAnalysis(CP3.normalizedPower, 'normalizedPower');


CP2 = CP2.defineInputs();
CP4 = CP4.defineInputs();
CP3 = CP3.defineInputs();

CP2.StreamingModel = CP2.StreamingModel.trainModel([]);
CP4.StreamingModel = CP4.StreamingModel.trainModel([]);
CP3.StreamingModel = CP3.StreamingModel.trainModel([]);

100*mean(CP2.StreamingModel.trainedModel.confusionMatrix.percentValidation,3)
100*mean(CP4.StreamingModel.trainedModel.confusionMatrix.percentValidation,3)
100*mean(CP3.StreamingModel.trainedModel.confusionMatrix.percentValidation,3)
100*std(CP3.StreamingModel.trainedModel.confusionMatrix.percentValidation,[], 3)

CP4.reportStreaming();
CP2.reportStreaming();
CP3.reportStreaming();
totalOutput =[];

for k=1:100
totalOutput(:,:,k)= CP2.StreamingModel.trainedModel.outputRuns(k).filteredOutput;
end

figure;
totalOutput = mean(totalOutput,3);
rgb = reshape(totalOutput', 1, size(totalOutput,2), 3);
imagesc(rgb)

CP2.StreamingModel.trainModel()

aux = 1:1:(length(CP3.Waves));
indexes1422 = aux(CP3.propertyVector('file') == 1422);

figure
for k=1:length(indexes1422)
  plot(CP3.Waves(k).rawData)
  title(CP3.Waves(k).absoluteTriggerIndex)
  pause;
end
    
end