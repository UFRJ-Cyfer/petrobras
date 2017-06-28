function model = trainMLP(input, target, runs, kCrossVal, useGPU, separationIndexes)

neuralNetStructure = [5];
net = patternnet(neuralNetStructure);
net.trainFcn = 'trainbr';
net.inputs{1}.processFcns = {'mapstd'};
trainingIndexes = struct;
duplicatePE = 1;
shuffledIndexes = randperm(size(target,2));

trainRatio = 65/100;
valRatio = 15/100;
testRatio = 20/100; % redundant

if strcmp(useGPU,'yes')
    net.trainFcn = 'trainscg';
end

if kCrossVal > 1
    
    validationSlotLenght = round(size(target,2)/kCrossVal);
    runs = 1;
    
    for k=0:kCrossVal-1
        if (k+1)*validationSlotLenght > size(target,2)
            trainingIndexes(k+1).valInd = shuffledIndexes(k*validationSlotLenght+1:end);
            trainingIndexes(k+1).trainInd = shuffledIndexes(~ismember(shuffledIndexes,trainingIndexes(k+1).valInd));
            if duplicatePE
               aux = trainingIndexes(k+1).trainInd;
               trainingIndexes(k+1).trainInd = [trainingIndexes(k+1).trainInd, aux(aux < separationIndexes.timePI & ...
                    aux > separationIndexes.timeSP)];
            end
        else
            trainingIndexes(k+1).valInd = shuffledIndexes(k*validationSlotLenght+1:(k+1)*validationSlotLenght);
            trainingIndexes(k+1).trainInd = shuffledIndexes(~ismember(shuffledIndexes, trainingIndexes(k+1).valInd));
            if duplicatePE
               aux = trainingIndexes(k+1).trainInd;
               trainingIndexes(k+1).trainInd = [trainingIndexes(k+1).trainInd, aux(aux < separationIndexes.timePI & ...
                   aux > separationIndexes.timeSP)];
            end
        end
    end
    
else
    net.divideFcn = 'divideind';  % Divide data randomly
    trainLength = ceil(size(target,2) * trainRatio);
    valLength = ceil(size(target,2) * valRatio);
    net.divideParam.trainInd = shuffledIndexes(1:trainLength);
    net.divideParam.valInd = shuffledIndexes(trainLength+1:trainLength+1+valLength);
    net.divideParam.testInd = shuffledIndexes(trainLength+1+valLength+1:end);
    kCrossVal = 1;
    
    if duplicatePE
        net.divideParam.trainInd = [net.divideParam.trainInd, ...
            net.divideParam.trainInd(net.divideParam.trainInd < separationIndexes.timePI & ...
            net.divideParam.trainInd < separationIndexes.timePI)];
    end
end

confusionMatrix.training = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);
confusionMatrix.validation = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);
confusionMatrix.test = zeros(size(target,1),size(target,1),runs + kCrossVal - 1);

net.trainParam.min_grad = 1e-16;
net.trainParam.max_fail = 10;
net.trainParam.lr = 0.1;
net.trainParam.showWindow = 0;
net.performFcn = 'crossentropy';  % Cross-Entropy

x = input;
t = target;

for m=1:runs
    
    for k=1:kCrossVal
        
        if kCrossVal > 1
            net.divideFcn = 'divideind';
            net.divideParam.trainInd = trainingIndexes(k).trainInd;
            net.divideParam.valInd = trainingIndexes(k).valInd;
            net.divideParam.testInd = [];
        end
        
        [net,tr] = train(net,x,t,'useGPU',useGPU);
        
        y = net(x);
        
        [~, i_max] =  max(y);
        aux = (1:size(target,1))';
        y_filtered = zeros(size(y));
        
        for j=1:size(i_max,2)
            y_filtered(:,j) = 1*(aux==i_max(j));
        end
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = t .* tr.trainMask{1};
        valTargets = t .* tr.valMask{1};
        testTargets = t .* tr.testMask{1};
        
        if kCrossVal > 1
            testTargets = t .* tr.valMask{1};
        end
        
        y_filtered_conf = y_filtered;
        
        model.outputRuns(m+k-1).trainTargets = trainTargets;
        model.outputRuns(m+k-1).valTargets = valTargets;
        model.outputRuns(m+k-1).testTargets = testTargets;
        
        for j=1:size(target,1)
            trainTargets(j,:) = j*trainTargets(j,:);
            valTargets(j,:) = j*valTargets(j,:);
            testTargets(j,:) = j*testTargets(j,:);
            
            y_filtered_conf(j,:) = j*y_filtered_conf(j,:);
        end
        
        trainTargets = sum(trainTargets,1);
        valTargets = sum(valTargets,1);
        testTargets = sum(testTargets,1);
        
        y_filtered_conf = sum(y_filtered_conf,1);
        
        confusionTrain = confusionmat(trainTargets,y_filtered_conf);
        confusionVal = confusionmat(valTargets,y_filtered_conf);
        confusionTest = confusionmat(testTargets,y_filtered_conf);
        
%         for j=1:size(target,1)
%             confusionTrain(j,:) = confusionTrain(j,:)/sum(confusionTrain(j,:));
%             confusionVal(j,:) = confusionVal(j,:)/sum(confusionVal(j,:));
%             confusionTest(j,:) = confusionTest(j,:)/sum(confusionTest(j,:));
%         end
        
        confusionMatrix.training(:,:,m+k-1) = confusionTrain;
        confusionMatrix.validation(:,:,m+k-1) = confusionVal;
        confusionMatrix.test(:,:,m+k-1) = confusionTest;
        

        model.outputRuns(m+k-1).filteredOutput = y_filtered;
        model.outputRuns(m+k-1).output = y;
        model.outputRuns(m+k-1).net = net;

    end
end

model.confusionMatrix = confusionMatrix;
model.modelDescription = 'MLP';
model.input = input;
model.target = target;

end


