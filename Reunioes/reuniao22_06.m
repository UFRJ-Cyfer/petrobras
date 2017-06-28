figure; 
plot(trainedModel.outputRuns(1).output(1,:),'.')
hold on;
plot(trainedModel.outputRuns(1).output(2,:),'.')
ylim = abs(max(trainedModel.outputRuns(1).output(1,:)));
plot([mainVallen.separationIndexes.timeSP mainVallen.separationIndexes.timeSP], [0 1], 'k--')
plot([mainVallen.separationIndexes.timePI mainVallen.separationIndexes.timePI], [0 1], 'k--')
title('neuronio SP')

figure; 
plot(trainedModel.outputRuns(1).output(2,:),'.')
hold on;
ylim = abs(max(trainedModel.outputRuns(1).output(2,:)));
plot([mainVallen.separationIndexes.timeSP mainVallen.separationIndexes.timeSP], [0 1], 'k--')
plot([mainVallen.separationIndexes.timePI mainVallen.separationIndexes.timePI], [0 1], 'k--')
title('neuronio PE')

figure; 
plot(trainedModel.outputRuns(1).output(3,:),'.')
hold on;
ylim = abs(max(trainedModel.outputRuns(1).output(3,:)));
plot([mainVallen.separationIndexes.timeSP mainVallen.separationIndexes.timeSP], [0 1], 'k--')
plot([mainVallen.separationIndexes.timePI mainVallen.separationIndexes.timePI], [0 1], 'k--')
title('neuronio PI')

% mainVallen25 = mainVallen;
% trainedModel25 = trainedModel;



outputVector = trainedModel.outputRuns(1).output;

codifiedVector = outputVector > 0.5;

sumCodified = sum(codifiedVector,1);

figure; plot(sumCodified,'.')
hold on;
plot([mainVallen.separationIndexes.timeSP mainVallen.separationIndexes.timeSP], [0 1], 'k--')
plot([mainVallen.separationIndexes.timePI mainVallen.separationIndexes.timePI], [0 1], 'k--')

figure;
histogram(outputVector(1,:),10)
title('SP')
figure;
histogram(outputVector(2,:),10)
title('PE')
