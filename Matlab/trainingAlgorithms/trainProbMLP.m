function model = trainProbMLP(input, target, runs, kCrossVal, useGPU, separationIndexes)

neuralNetStructure = [15];
net = patternnet(neuralNetStructure);
net.trainFcn = 'trainbr';
net.performFcn = 'mse';
net.layers{end}.transferFcn  = 'logsig';
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

% separationIndexes.timeSP = find(target(2,:),1)-1;
% separationIndexes.timePI = find(target(3,:),1);

separationIndexes.timeSP = 487;
separationIndexes.timePI = 487+793;

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
        else
            trainingIndexes(k+1).valInd = shuffledIndexes(k*validationSlotLenght+1:(k+1)*validationSlotLenght);
            trainingIndexes(k+1).trainInd = shuffledIndexes(~ismember(shuffledIndexes, trainingIndexes(k+1).valInd));
        end
    end
    
else
    net.divideFcn = 'divideind';  % Divide data randomly
    trainLength = ceil(size(target,2) * trainRatio);
    valLength = floor(size(target,2) * valRatio);
    net.divideParam.trainInd = shuffledIndexes(1:trainLength);
    net.divideParam.valInd = shuffledIndexes(trainLength+1:trainLength+valLength);
    net.divideParam.testInd = shuffledIndexes(trainLength+1+valLength:end);
    kCrossVal = 1;
    
end


net.trainParam.min_grad = 1e-16;
net.trainParam.max_fail = 100;
net.trainParam.lr = 0.1;
net.trainParam.showWindow = 0;
% net.performFcn = 'crossentropy';  % Cross-Entropy

x = input;
t = target;

for m=1:runs
    m
    for k=1:kCrossVal
        
        if kCrossVal > 1
            net.divideFcn = 'divideind';
            net.divideParam.trainInd = trainingIndexes(k).trainInd;
            net.divideParam.valInd = trainingIndexes(k).valInd;
            net.divideParam.testInd = [];
            
            [net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] = ...
                balanceClasses(net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd, separationIndexes);
            
        end
        
        if runs > 1
            shuffledIndexes = randperm(size(target,2));
            net.divideFcn = 'divideind';
            net.divideParam.trainInd = shuffledIndexes(1:trainLength);
            net.divideParam.valInd = shuffledIndexes(trainLength+1:trainLength+valLength);
            net.divideParam.testInd = shuffledIndexes(trainLength+1+valLength:end);
            
            [net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] = ...
                balanceClasses(net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd, separationIndexes);
            
        end
        
        [net_,tr] = train(net,x,t,'useGPU',useGPU);
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = t .* tr.trainMask{1};
        valTargets = t .* tr.valMask{1};
        testTargets = t .* tr.testMask{1};
        
        if kCrossVal > 1
            testTargets = t .* tr.valMask{1};
        end
        
        
        model.outputRuns(m+k-1).trainTargets = trainTargets;
        model.outputRuns(m+k-1).valTargets = valTargets;
        model.outputRuns(m+k-1).testTargets = testTargets;
        
        y = net_(x);
%         model.outputRuns(m+k-1).filteredOutput = y_filtered;
        model.outputRuns(m+k-1).output = y;
        model.outputRuns(m+k-1).net = net_;
        model.outputRuns(m+k-1).tr = tr;
        
    end
end

model.modelDescription = 'MLP';
model.input = input;
model.target = target;

end
