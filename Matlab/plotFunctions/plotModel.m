function figureHandles = plotModel(trainedModel)

lastTrainIndex = length(trainedModel.outputRuns);
totalOutput = trainedModel.outputRuns(lastTrainIndex).filteredOutput;
totalTargets = trainedModel.target;


trainTargets = trainedModel.outputRuns(lastTrainIndex).trainTargets;
valTargets = trainedModel.outputRuns(lastTrainIndex).valTargets;
testTargets = trainedModel.outputRuns(lastTrainIndex).testTargets;

outputTrain = totalOutput(:,~isnan(trainTargets(1,:)));
outputVal = totalOutput(:,~isnan(valTargets(1,:)));
outputTest = totalOutput(:,~isnan(testTargets(1,:)));

trainTargets = trainTargets(:,~isnan(trainTargets(1,:)));
valTargets = valTargets(:,~isnan(valTargets(1,:)));
testTargets = testTargets(:,~isnan(testTargets(1,:)));

testTargetsClassified = testTargets .* repmat([1;2;3],1,size(testTargets,2));
testTargetsClassified = sum(testTargetsClassified, 1);
[~,indexesToSort] = sort(testTargetsClassified);


targetRGB = reshape(totalTargets', 1, size(totalTargets, 2), 3);
outputRGB = reshape(totalOutput', 1, size(totalOutput, 2), 3);

testTargetRGB = reshape(testTargets(:,indexesToSort)', 1, size(testTargets, 2), 3);
testOutputRBG = reshape(outputTest(:,indexesToSort)', 1, size(outputTest, 2), 3);

completeRGBFigure = figure;
subplot(2,1,1)
imagesc(targetRGB)
title('Referência')


subplot(2,1,2)
imagesc(outputRGB)
xlabel('Índice')


testRGBFigure = figure;
subplot(2,1,1)
imagesc(testTargetRGB)
title('Referência')


subplot(2,1,2)
imagesc(testOutputRBG)
xlabel('Índice')


hAllAxes = findobj(completeRGBFigure,'type','axes');

for i=1:length(hAllAxes)
    axes(hAllAxes(i))
    colormap(eye(3))
    hold on
    L = line(ones(3),ones(3), 'LineWidth',2);               % generate line
    set(L,{'color'},mat2cell(eye(3),ones(1,3),3));            % set the colors according to cmap
    legend('SP','PE','PI')
end

hAllAxes = findobj(testRGBFigure,'type','axes');

for i=1:length(hAllAxes)
    axes(hAllAxes(i))
    colormap(eye(3))
    hold on
    L = line(ones(3),ones(3), 'LineWidth',2);               % generate line
    set(L,{'color'},mat2cell(eye(3),ones(1,3),3));            % set the colors according to cmap
    legend('SP','PE','PI')
end

figureHandles.completeRGBFigure = completeRGBFigure;
figureHandles.testRGBFigure = testRGBFigure;

end