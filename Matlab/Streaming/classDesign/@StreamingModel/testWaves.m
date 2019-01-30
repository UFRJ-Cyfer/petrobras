function [ outputClasses, confusionMatrix ] = testWaves( this, indexes )
%TESTWAVES Summary of this function goes here
%   Detailed explanation goes here
dimensions = 1:15;
tm = this.trainedModel;
x = this.input.normalizedPower(dimensions,indexes);
x = normalizeData(x,1);

target = this.target(:,indexes);
confusionMatrix = zeros(size(target,1),size(target,1),length(tm.outputRuns));

aux = repmat([1:size(target,1)]',1, size(target,2));
target = sum(target.*aux,1);
outputClasses = zeros(length(tm.outputRuns), length(target));

for k=1:length(tm.outputRuns)
    net = tm.outputRuns(k).net;
    y = net(x);
    [~, i_max] =  max(y);
    outputClasses(k,:) = i_max;
    confusionMatrix(:,:,k) = confusionmat(target, i_max);
    confusionMatrix(:,:,k) = confusionMatrix(:,:,k)./repmat(sum(confusionMatrix(:,:,k),2), 1,3);
end

end

