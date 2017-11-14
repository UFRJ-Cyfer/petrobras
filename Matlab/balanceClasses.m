function [trainIndex, valIndex, testIndex] = ...
    balanceClasses(trainIndex, valIndex, testIndex, separationIndexes)

totalSamples = length(trainIndex) + length(valIndex) + length(testIndex);
separationIndexes.timeSP
separationIndexes.timePI

% Using training data set
numSPSamples = sum(trainIndex <= separationIndexes.timeSP);
numPISamples = sum(trainIndex >= separationIndexes.timePI);
numPESamples = length(trainIndex) - numPISamples - numSPSamples;

% % Using whole data set
% numSPSamples = separationIndexes.timeSP;
% numPISamples = totalSamples - separationIndexes.timePI;
% numPESamples = separationIndexes.timePI - separationIndexes.timeSP;

trainSPIndexes = trainIndex(trainIndex <= separationIndexes.timeSP);
trainPEIndexes = trainIndex(trainIndex < separationIndexes.timePI & ...
    trainIndex > separationIndexes.timeSP);
trainPIIndexes = trainIndex(trainIndex >= separationIndexes.timePI);

classesIndexes(1).index = trainSPIndexes;
classesIndexes(2).index = trainPEIndexes;
classesIndexes(3).index = trainPIIndexes;

samplesVector = [numSPSamples numPESamples numPISamples];

differences = max(samplesVector)- samplesVector;

for k=1:3
    if differences(k) > 0
        i = 1;
        for j=1:differences(k)
            trainIndex = [trainIndex classesIndexes(k).index(i)];
            i = i+1;
            if i > length(classesIndexes(k).index)
               i = 1; 
            end
        end
    end
end

end