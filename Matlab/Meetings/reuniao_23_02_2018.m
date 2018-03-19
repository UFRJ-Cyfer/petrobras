firstFileToOpen = 140;
lastFileToOpen = 1500;

filesToPlot = firstFileToOpen:lastFileToOpen;

plotVector = zeros(1,ceil((16777216/100)*(lastFileToOpen-firstFileToOpen+1)),'int16');

index = 0;
for j= filesToPlot
    
load(['J:\BACKUPJ\ProjetoPetrobras\extractedChannel\chanel12Extracted' num2str(j) 'CP3.mat'])
plotVector(index+1:index+ceil((16777216/100))) = extratedChannel(1:100:16777216);
index = index + ceil((16777216/100));
j
end

tempo = 1:1:length(plotVector);
tempo = tempo*100/(2.5e6);
% 
% plotVector = plotVector - mean(plotVector);
% extratedChannel = extratedChannel - mean(extratedChannel);

% figure;
% plot(tempo,plotVector);
% 
% figure;
% plot(extratedChannel);
% 
% figure(1)
% plot(tempo(1:100:16777216),plotVector(1:ceil(16777216/100)))

% 
% % 514, 543 558, 669 687, 711 729, 751 769

% fileRange = [255 280];firstIndex = (fileRange(1) - 514)*ceil(16777216/100)+1;lastIndex = firstIndex + (fileRange(2) - fileRange(1) + 1)*ceil(16777216/100)-1;plot(tempo(firstIndex:lastIndex),plotVector(firstIndex:lastIndex)); axis([-inf inf -600 600]);
% hold on;
% subplot(3,1,2)
% subplot(3,1,3)
% figure(4)
% 
% beginIndexesToCheck = [141, 251, 271, 301, 321, 451, 471, 491, 511, 541, 551, 661, 681, 711, 721,751, 761, 881, 901, 921, 941, 1041];

beginIndexesToCheck = [1061, 1081, 1101, 1211, 1241, 1261, 1291, 1391];

for j=1:length(beginIndexesToCheck)
for k_ = beginIndexesToCheck(j):beginIndexesToCheck(j)+9
 
    figure(3)
    fileRange = [k_ k_];firstIndex = (fileRange(1) - 140)*ceil(16777216/100)+1;lastIndex = firstIndex + (fileRange(2) - fileRange(1) + 1)*ceil(16777216/100)-1;plot(tempo(firstIndex:lastIndex),plotVector(firstIndex:lastIndex)); axis([-inf inf -inf inf]);
    title(['Arquivo ' num2str(k_) '-' num2str(k_)])
    pause
end 
end 


filesToRemove = [1:144, 145, 187:224, 255, 256, 272, 273, 305, 321, 320, 453, ...
454, 471, 498, 499, 514 ,515, 543, 558, 559, 669, 670, 686,...
    687, 711, 729, 751, 769, 770, 883, 902, 903, 921, 941, 942,...
    1046, 1068, 1083, 1109, 1110, 1217, 1250, 1264, 1297, 1397];

indexesToRemoveFiles = [];
for l=1:length(filesToRemove)
    indexesToRemoveFiles = [indexesToRemoveFiles find(streamingStruct(3).fileNumber ==filesToRemove(l))];
end

    streamingStruct(3).rawData(:,indexesToRemoveFiles) = [];
    streamingStruct(3).channel(:,indexesToRemoveFiles) = [];
    streamingStruct(3).resolution(:,indexesToRemoveFiles) = [];
    streamingStruct(3).startingTime(:,indexesToRemoveFiles) = [];
    streamingStruct(3).triggerTime(:,indexesToRemoveFiles) = [];
    streamingStruct(3).fileNumber(:,indexesToRemoveFiles) = [];
    
tempo = 0:1:42499;
tempo = tempo/(2.5e6);

for j =974:1300

   file = streamingStruct(3).fileNumber(j);
   file = find(streamingStruct(3).noiseLevelMatrix(:,1) == file);
   filePlot = streamingStruct(3).fileNumber(j);
   startWaveTime = streamingStruct(3).startingTime(j);
   
   figure(2)
   hold off;
   plot(tempo+startWaveTime,streamingStruct(3).rawData(:,j));
   hold on;
   
   channel = streamingStruct(3).channel(j);
   plot(tempo+startWaveTime,ones(size(streamingStruct(3).rawData(:,j)))...
       *streamingStruct(3).noiseLevelMatrix(file,channel+1),'k--')
   
    plot(tempo+startWaveTime,ones(size(streamingStruct(3).rawData(:,j)))...
       *-1*streamingStruct(3).noiseLevelMatrix(file,channel+1),'k--')
      title(['Arquivo ' num2str(filePlot) ' Onda ' num2str(j)])
   pause;
end

zeroCount = [];
diffZeroCount = [];
for j = 1:size(streamingStruct(3).rawData,2)
    zeroCount(j) = sum(streamingStruct(3).rawData(:,j) == 0);
    diffZeroCount(j) = sum(diff(streamingStruct(3).rawData(:,j)) == 0);
end

figure;
plot(zeroCount,'.')
plot(diffZeroCount,'.')

indexesToRemoveNoise = [];
for l_ = 1:992
   file = streamingStruct(3).fileNumber(l_);
   file = find(streamingStruct(3).noiseLevelMatrix(:,1) == file);
   file = streamingStruct(3).noiseLevelMatrix(file,1);
   
   channel = streamingStruct(3).channel(l_);
   noise = streamingStruct(3).noiseLevelMatrix(file,channel+1);
   
   if ~isempty(find(streamingStruct(3).rawData(:,l_) >= 30*noise))
       indexesToRemoveNoise = [indexesToRemoveNoise l_];
       auxIndex = 1;
       while auxIndex ~=0
           if (channel == streamingStruct(3).channel(l_+auxIndex)) && (diff(streamingStruct(3).startingTime([l_+auxIndex-1 l_+auxIndex])) < 0.016)
               indexesToRemoveNoise = [indexesToRemoveNoise l_+auxIndex];
               auxIndex =auxIndex +1;
           else
               auxIndex = 0;
           end
       end
   end
end
indexesToRemoveNoise = unique(indexesToRemoveNoise);

    streamingStruct(3).rawData(:,indexesToRemoveNoise) = [];
    streamingStruct(3).channel(:,indexesToRemoveNoise) = [];
    streamingStruct(3).resolution(:,indexesToRemoveNoise) = [];
    streamingStruct(3).startingTime(:,indexesToRemoveNoise) = [];
    streamingStruct(3).triggerTime(:,indexesToRemoveNoise) = [];
    streamingStruct(3).fileNumber(:,indexesToRemoveNoise) = [];
    
    
tempoRawData = 0:1:(2^24-1);
tempoRawData = tempoRawData/(2.5e6);
tempoRawDataMax = tempoRawData(end);

figure;
plot(tempoRawData + tempoRawDataMax*249, rawData(:,12))


    indexesToRemoveNaN =[];
for l_ = 1:length(streamingStruct(3).channel)
   
   if sum(isnan(streamingStruct(3).rawData(:,l_))) >= 1
       indexesToRemoveNaN = [indexesToRemoveNaN l_];
   end
end

    indexesToRemoveZeroCount = (zeroCount>5500);
        streamingStruct(3).rawData(:,indexesToRemoveZeroCount) = [];
    streamingStruct(3).channel(:,indexesToRemoveZeroCount) = [];
    streamingStruct(3).resolution(:,indexesToRemoveZeroCount) = [];
    streamingStruct(3).startingTime(:,indexesToRemoveZeroCount) = [];
    streamingStruct(3).triggerTime(:,indexesToRemoveZeroCount) = [];
    streamingStruct(3).fileNumber(:,indexesToRemoveZeroCount) = [];
    
    
    figure;
    tempoPlot =0:1:2^24-1;
    tempoPlot= tempoPlot/(2.5e6);
    
    for k = 1397:1425
       load(['chanel12Extracted' num2str(k) 'CP3.mat']);
       plot(tempoPlot,extratedChannel)
       title(['arquivo ' num2str(k)])
       saveas(gcf,['images\channel12arquivo' num2str(k) '.png'])
    end
