 neuralNetOutput = trainedModel.outputRuns(4).filteredOutput;
 target = trainedModel.target;
 
 mainVallen.separationIndexes.timeSP
 mainVallen.separationIndexes.timePI

 indexes = 1:725;
 % Regiao de PE  e PI que foi classificada como SP
 indexesToMantain = indexes(~(neuralNetOutput(1,:) == 1 & (indexes >  mainVallen.separationIndexes.timeSP)));
 
 neuralNetInputNew = neuralNetInput(:,indexesToMantain);
 target = target(:,indexesToMantain);
 
 trainedModelNew = mainTrain(neuralNetInputNew, target, method);
  indexesToRemove = indexes((neuralNetOutput(1,:) == 1 & (indexes >  mainVallen.separationIndexes.timeSP)));

   [ismem___,testIndex___] = ismember(indexesToRemove,mainVallen.waveIndexesNewAndOld(2,:));
 [ismem,testIndex] = ismember(mainVallen.waveIndexesNewAndOld,waveIndexes);
 
 timeVectorCalobaPlot = [];
indexCaloba = 1;
for k=1:length(indexesToRemove)
    I = find(mainVallen.waveIndexesNewAndOld(2,:) == indexesToRemove(k));
    waveIndexRequested = mainVallen.waveIndexesNewAndOld(1,I);
    
    I = find(waveIndexes == waveIndexRequested);
    timeVectorCalobaPlot(k) = timeVector(I);
end
 
 figure
 plot((timeVectorCalobaPlot), ones(size(timeVectorCalobaPlot)),'b.')
 hold on
 plot([timeVector(waveIndexes==897) timeVector(waveIndexes==897)],[0 2], 'k--')
 plot([timeVector(waveIndexes==1300) timeVector(waveIndexes==1300)],[0 2], 'r--')
 
 
 
 
 
 figure;
 plot(timeVector(testIndex), ones(size(timeVector(testIndex))),'b.')
 
 
  