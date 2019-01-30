function model = trainMLP_fix(input, target, runs, kCrossVal, useGPU, neuralNetStructure)

net = patternnet(neuralNetStructure);
net.trainFcn = 'trainbr';
net.performFcn = 'mse';
net.layers{end}.transferFcn  = 'tansig';
% for k=1:length(net.layers)
%    net.layers{k}.initFcn = 'rands';
% end
% net.init;
% net.trainParam.max_fail = 0;
% net.inputs{1}.processFcns = {'mapstd'};
trainingIndexes = struct;
duplicatePE = 0;
shuffledIndexes = randperm(size(target,2));
trainRatio = 65/100;
valRatio = 35/100;
testRatio = 0/100; % redundant

if strcmp(useGPU,'yes')
    net.trainFcn = 'trainscg';
end

net.divideFcn = 'divideind';  % Divide data randomly


if kCrossVal > 1
    
    runs = 1;
    
else
    net.divideFcn = 'divideind';  % Divide data randomly
    trainLength = ceil(size(target,2) * trainRatio);
    valLength = floor(size(target,2) * valRatio);
    net.divideParam.trainInd = shuffledIndexes(1:trainLength);
    net.divideParam.valInd = shuffledIndexes(trainLength+1:trainLength+valLength);
    net.divideParam.testInd = shuffledIndexes(trainLength+1+valLength:end);
    kCrossVal = 1;
    
end

confusionMatrix.training = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);
confusionMatrix.validation = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);
confusionMatrix.test = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);
%
net.trainParam.min_grad = 1e-16;
net.trainParam.max_fail = 100;
net.trainParam.lr = 0.15;
net.trainParam.showWindow = 0;
% net.performFcn = 'crossentropy';  % Cross-Entropy

x = input;
t = target;

nClasses = size(target,1);

classDivider = zeros(nClasses-1,1);

for k=1:(nClasses-1)

classDivider(k) = find(target(k,:), 1, 'last')+1;

end

for m=1:runs
    m
    for k=1:kCrossVal
        
        if kCrossVal > 1
            net.divideFcn = 'divideind';
            net.divideParam.trainInd = trainingIndexes(k).trainInd;
            net.divideParam.valInd = trainingIndexes(k).valInd;
            net.divideParam.testInd = [];

            [ew_, ew] = balanceClassesW(net.divideParam.trainInd, size(target,2), classDivider);
            
        end
        
        if runs > 1
            shuffledIndexes = randperm(size(target,2));
            net.divideFcn = 'divideind';
            net.divideParam.trainInd = shuffledIndexes(1:trainLength);
            net.divideParam.valInd = shuffledIndexes(trainLength+1:trainLength+valLength);
            net.divideParam.testInd = shuffledIndexes(trainLength+1+valLength:end);
 
           [ew_, ew] = balanceClassesW(net.divideParam.trainInd, size(target,2), classDivider);
        end
        
        ew_
        [net_,tr] = train(net,x,t,{},{},ew,'useGPU',useGPU);

        y = net_(x);
        
        [~, i_max] =  max(y);
        y_filtered_conf = i_max;
        
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = t .* tr.trainMask{1};
        valTargets = t .* tr.valMask{1};
        testTargets = t .* tr.testMask{1};
        
        if kCrossVal > 1
            testTargets = t .* tr.valMask{1};
        end
        
        %         y_filtered_conf = y_filtered;
        
        model.outputRuns(m+k-1).trainTargets = trainTargets;
        model.outputRuns(m+k-1).valTargets = valTargets;
        model.outputRuns(m+k-1).testTargets = testTargets;
        
        for j=1:size(target,1)
            trainTargets(j,:) = j*trainTargets(j,:);
            valTargets(j,:) = j*valTargets(j,:);
            testTargets(j,:) = j*testTargets(j,:);
            
            %             y_filtered_conf(j,:) = j*y_filtered_conf(j,:);
        end
        
        trainTargets = sum(trainTargets,1);
        valTargets = sum(valTargets,1);
        testTargets = sum(testTargets,1);
        
        y_filtered_conf = sum(y_filtered_conf,1);
        
        confusionTrain = confusionmat(trainTargets,y_filtered_conf);
        confusionVal = confusionmat(valTargets,y_filtered_conf);
        
        if testRatio == 0
            confusionTest = confusionVal;
        else
            confusionTest = confusionmat(testTargets,y_filtered_conf);
        end
        
        acc = trace(confusionTest) / sum(sum(confusionTest));
        confusionTrainPercentage = confusionTrain;
        confusionValPercentage = confusionVal;
        confusionTestPercentage = confusionTest;
        %
        for j=1:size(target,1)
            %         for j=1:3
            confusionTrainPercentage(j,:) = confusionTrain(j,:)/sum(confusionTrain(j,:));
            confusionValPercentage(j,:) = confusionVal(j,:)/sum(confusionVal(j,:));
            confusionTestPercentage(j,:) = confusionTest(j,:)/sum(confusionTest(j,:));
        end
        
        confusionMatrix.training(:,:,m+k-1) = confusionTrain;
        confusionMatrix.validation(:,:,m+k-1) = confusionVal;
        confusionMatrix.test(:,:,m+k-1) = confusionTest;
        
        confusionMatrix.percentTraining(:,:,m+k-1) = confusionTrainPercentage;
        confusionMatrix.percentValidation(:,:,m+k-1) = confusionValPercentage;
        confusionMatrix.percentTest(:,:,m+k-1) = confusionTestPercentage;
        model.acc(m+k-1) = acc;
        
        %         model.outputRuns(m+k-1).filteredOutput = y_filtered;
        model.outputRuns(m+k-1).output = y;
        model.outputRuns(m+k-1).net = net_;
        
        model.outputRuns(m+k-1).tr = tr;
        
    end
end
model.confusionMatrix = confusionMatrix;
model.modelDescription = 'MLP';
model.input = input;
model.target = target;

end


