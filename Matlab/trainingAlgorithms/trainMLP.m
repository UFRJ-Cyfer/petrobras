function model = trainMLP(input, target, runs, kCrossVal, useGPU)

neuralNetStructure = [5];
net = patternnet(neuralNetStructure);
net.trainFcn = 'trainbr';
net.inputs{1}.processFcns = {'mapstd'};
trainingIndexes = struct;


if strcmp(useGPU,'yes')
    net.trainFcn = 'trainscg';
end

if kCrossVal > 1
    
    shuffledIndexes = randperm(size(target,2));
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
    net.divideFcn = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';  % Divide up every sample
    net.divideParam.trainRatio = 65/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 20/100;
    kCrossVal = 1;
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
        
        % figure;
        % y_filtered_rgb = reshape(y_filtered',1,size(i_max,2),3);
        % t_rgb = reshape(t',1,size(i_max,2),3);
        % imagesc(t_rgb)
        %
        % y_rgb = reshape(y',1,size(i_max,2),3);
        % figure
        % imagesc(y)
        % figure
        % subplot(2,1,2)
        % test_indexes = ~isnan(tr.testMask{1});
        % imagesc(y_filtered_rgb(:,test_indexes(1,:),:))
        %
        % subplot(2,1,1)
        % imagesc(t_rgb(:,test_indexes(1,:),:))
        
        
        
        % figure(6);
        % title('Referência')
        % colormap(eye(3))
        % hold on
        % L = line(ones(3),ones(3), 'LineWidth',2);               % generate line
        % set(L,{'color'},mat2cell(eye(3),ones(1,3),3));            % set the colors according to cmap
        % legend('SP','PE','PI')
        %
        % figure(4)
        % title('Saída da Rede')
        % xlabel('Índice da entrada')
        
        %
        % plot(y(i_max,:))
        % plot(i_max,'.')
        % hold on;
        % plot(t);
        % plot(zeros(size(t)),'k--')
        
        
        % e = gsubtract(t,y);
        % performance = perform(net,t,y)
        % tind = vec2ind(t);
        % yind = vec2ind(y);
        % percentErrors = sum(tind ~= yind)/numel(tind);
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = t .* tr.trainMask{1};
        valTargets = t .* tr.valMask{1};
        testTargets = t .* tr.testMask{1};
        
        if kCrossVal > 1
            testTargets = t .* tr.valMask{1};
        end
        
        y_filtered_conf = y_filtered;
        
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
        
        for j=1:size(target,1)
            confusionTrain(j,:) = confusionTrain(j,:)/sum(confusionTrain(j,:));
            confusionVal(j,:) = confusionVal(j,:)/sum(confusionVal(j,:));
            confusionTest(j,:) = confusionTest(j,:)/sum(confusionTest(j,:));
        end
        
        confusionMatrix.training(:,:,m+k-1) = confusionTrain;
        confusionMatrix.validation(:,:,m+k-1) = confusionVal;
        confusionMatrix.test(:,:,m+k-1) = confusionTest;
        
        model.outputRuns(m+k-1).trainTargets = trainTargets;
        model.outputRuns(m+k-1).valTargets = valTargets;
        model.outputRuns(m+k-1).testTargets = testTargets;
        model.outputRuns(m+k-1).filteredOutput = y_filtered;
        model.outputRuns(m+k-1).output = y;
        model.outputRuns(m+k-1).net = net;

    end
end

model.confusionMatrix = confusionMatrix;

end


