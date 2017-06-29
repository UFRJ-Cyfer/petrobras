load('mainDataAmplitude25.mat')

neuralNetOutput = trainedModel.outputRuns(4).filteredOutput;
target = trainedModel.target;

mainVallen.separationIndexes.timeSP
mainVallen.separationIndexes.timePI
indexes = 1:size(target,2);


% Regiao de PE  e PI que foi classificada como SP
indexesToMantain = indexes(~(neuralNetOutput(1,:) == 1 & (indexes >  mainVallen.separationIndexes.timeSP)));
indexesToRemove = indexes((neuralNetOutput(1,:) == 1 & (indexes >  mainVallen.separationIndexes.timeSP)));


neuralNetInputNew = trainedModel.input(:,indexesToMantain);
target = trainedModel.target(:,indexesToMantain);

newTrainedModel = mainTrain(neuralNetInputNew, target, method,mainVallen.separationIndexes);


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