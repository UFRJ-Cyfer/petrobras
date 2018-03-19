% figure(1);
figure(2);
figure(3);
fs=2.5e6;

for file=[885]
    load(['extractedChannel/chanel12Extracted' num2str(file) 'CP3.mat'])
   extratedChannel = extratedChannel - mean(extratedChannel);
%    figure(1);
%    plot(extratedChannel,'.'); hold on;
%    plot(diff(extratedChannel),'.'); hold off;
%    title(['Arquivo ' num2str(file)])
%    drawnow;

   noiseLevel = 3*std(diff(double(extratedChannel)));
   
   figure(2);
   plot(extratedChannel,'.'); hold on;
   plot(noiseLevel*ones(size(extratedChannel)),'k--','LineWidth',1.5); hold on;
   plot(-noiseLevel*ones(size(extratedChannel)),'k--','LineWidth',1.5); hold off;
   title(['Arquivo ' num2str(file)])
    axis([-inf inf -300 300])
   
% end

timeVector = 0:1:length(extratedChannel)-1;
timeVector = timeVector/(2.5e6);

% thresholdSignalsPositions = (abs(extratedChannel) > 5*noiseLevel);
thresholdSignalsPositions = (abs(diff(extratedChannel)) > 2.5*noiseLevel);

% 
% figure(4);
% plot(timeVector(thresholdSignalsPositions),extratedChannel(thresholdSignalsPositions),'.')
% aux = timeVector(thresholdSignalsPositions);
% plot(aux(1:end-1),diff(aux),'.')
indexes = find(thresholdSignalsPositions);

diffIndexes = diff(indexes);
diffIndexes (diffIndexes<10000) =0;
startingLocation = find(diffIndexes ~=0);
startingIndexes = [indexes(1); indexes(startingLocation+1); indexes(end)];

allWavesLocation = extratedChannel > noiseLevel;

TOLERANCE = 10/100;

diffStartingIndexes = diff(startingIndexes);

diffStartingIndexes(diffStartingIndexes < 0.02*fs*(1+TOLERANCE) & ...
    diffStartingIndexes > 0.02*fs*(1-TOLERANCE)) = 0.02*fs;

diffStartingIndexes(diffStartingIndexes < fs*(1+TOLERANCE) & ...
    diffStartingIndexes > fs*(1-TOLERANCE)) = fs;

tofdIndexes = [];
for l=1:length(diffStartingIndexes)
   if diffStartingIndexes(l) == 0.02*fs
       tofdIndexes = [tofdIndexes l l+1];
   end
end
tofdIndexes = unique(tofdIndexes);
firstFive = startingIndexes(tofdIndexes);

%%% finding first tofd block
% firstFive = startingIndexes(1:11);

slots = [];
zeroSlotBackward = 1000;
zeroSlotForward = 0;

for k=1:length(firstFive)
    if k == length(firstFive)
     aux = find((diff(extratedChannel(firstFive(k):end))) >= noiseLevel); 
    else
    aux = find((diff(extratedChannel(firstFive(k):firstFive(k+1)))) >= noiseLevel); 
    end
    nextWaveIndexes = find(diff(aux) > 1000);
    
    if ~isempty(nextWaveIndexes)
        aux = aux(1:nextWaveIndexes-1);
    end
    
    if firstFive(k) < (zeroSlotBackward+1)
        firstFive(k) = zeroSlotBackward+1;
    end
    if firstFive(k)+aux(end)+zeroSlotForward > 16777216
        aux(end) = 16777216 - zeroSlotBackward- firstFive(k);
    end
    slots = [slots firstFive(k)-zeroSlotBackward:(firstFive(k)+aux(end)+zeroSlotForward)];
end

cleanExtracted = extratedChannel;
cleanExtracted(slots) = 0;
figure(3)
plot(cleanExtracted,'.')
axis([-inf inf -300 300])
title(['Arquivo ' num2str(file) ' Sem TOFD'])
end
saveAllFigures

rawData = readStreamingFile( 'IDR2_ensaio_03#885.tdms', 'N:\CP3\Ciclo1' );

rawDataClean = removeTOFD(rawData);

figure;
for k=1:16
    subplot(2,1,1)
    plot(rawData(:,k)- mean(rawData(:,k)))
    title('Dirty')
    
    subplot(2,1,2)
    plot(rawDataClean(:,k))
    title(['Clean Canal ' num2str(k)])
    pause;
end



