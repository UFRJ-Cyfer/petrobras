function trainedModel = mainTrain(input, target, method)

if strcmp(method, 'MLP')
    runs = 100;
    kCrossVal = 5;
    useGPU = 'no';
    trainedModel = trainMLP(input,target,runs,kCrossVal,useGPU);    
end

if strcmp(method, 'SKN')
    trainedModel = trainSKN(input,target);
end

if strcmp(method, 'SOM')
    trainedModel = trainSOM(input,target);
end

end