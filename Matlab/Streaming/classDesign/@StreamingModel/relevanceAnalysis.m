function [this, rel] = relevanceAnalysis(this, streamingModel)

auxCP = (1:size(this.target,2));
dimensions = [2,5,7:18];

% this.input.normalizedPower = this.input.normalizedPower(dimensions,:);
indexesBTZ = this.input.normalizedPower > 0;
% this.input.normalizedPower(indexesBTZ) =...
%     log10(this.input.normalizedPower(indexesBTZ));

if nargin <2 
    rel.refModel = this.trainModel(auxCP,[10]);
    rel.accRef = rel.refModel.trainedModel.acc;
     refModel = rel.refModel.trainedModel;

else
    rel.refModel = streamingModel;
    rel.accRef = streamingModel.trainedModel.acc;
    refModel = rel.refModel.trainedModel;
end

acc = zeros(length(dimensions),length(refModel.outputRuns));
for n=1:length(refModel.outputRuns)
    net = refModel.outputRuns(n).net;
    if sum(sum(~isnan(refModel.outputRuns(n).testTargets))) > 0
        target = refModel.outputRuns(n).testTargets;
        
    else
        target = refModel.outputRuns(n).valTargets;
    end
    
    for j=1:size(target,1)
        target(j,:) = j*target(j,:);
    end
    
    target = sum(target,1);
    testIndexes = ~isnan(target);
    for k=1:length(dimensions)
        netInput = this.input.normalizedPower(dimensions,:);
        
        netInput = normalizeData(netInput,1);

        netInput(k,testIndexes) = ones(size(this.input.normalizedPower(k,testIndexes))) * ...
           mean(this.input.normalizedPower(k,testIndexes));
       
      
        y = net(netInput);
        [~, i_max] =  max(y);
        y_filtered_conf = sum(i_max,1);
        
        confusionTest = confusionmat(target,y_filtered_conf);
        
        acc(k,n) = trace(confusionTest)/sum(sum(confusionTest));
    end
end
delta = -(acc - repmat(rel.accRef,size(acc,1),1));
figure
hold on;
bar(mean(delta,2))
errorbar(1:(size(delta,1)),mean(delta,2), std(delta,[],2))
% plot(ones(1,size(delta,1))*mean(rel.accRef), '--')


end