function this = trainModel(this, includeIndexes, neuralNetStructure)

dimensions = [1:18];

input = this.input.normalizedPower(dimensions,:);
target = this.target;

if ~isempty(includeIndexes)
    removeIndexes  = setdiff(1:size(input,2), includeIndexes);
else
    removeIndexes = [];
end
input(:,removeIndexes) = [];
target(:,removeIndexes) = [];

this.trainedModel = mainTrain(input, target, 'MLP', [], neuralNetStructure);
% this.trainedModel = mainTrain(input, target, 'MLPPROB', []);



end