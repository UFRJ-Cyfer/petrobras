index = 1;
weirdWaves = [];
while index <= size(streamingStruct(3).rawData,2)
   file = streamingStruct(3).fileNumber(index);
   file = find(streamingStruct(3).noiseLevelMatrix(:,1) == file);
    filePlot = streamingStruct(3).noiseLevelMatrix(file,1);
   startWaveTime = streamingStruct(3).startingTime(index);
   
   figure(2)
   hold off;
   plot(tempo+startWaveTime,streamingStruct(3).rawData(:,index));
   hold on;
   
   channel = streamingStruct(3).channel(index);
   plot(tempo+startWaveTime,ones(size(streamingStruct(3).rawData(:,index)))...
       *streamingStruct(3).noiseLevelMatrix(file,channel+1),'k--')
   
    plot(tempo+startWaveTime,ones(size(streamingStruct(3).rawData(:,index)))...
       *-1*streamingStruct(3).noiseLevelMatrix(file,channel+1),'k--')
      title(['Arquivo ' num2str(filePlot) ' Onda ' num2str(index)])
      
      [~,~,button] = ginput(1);
      if button == 3
        weirdWaves = [weirdWaves index];
      end
      
    index = index+1;
end


for channel = 1:16
   figure(10)
   noiseMatrix = streamingStruct(3).noiseLevelMatrix(1:1235,:);
%    noiseMatrix(1160,:) = [];
   (plot(noiseMatrix(:,channel+1)))
   pause;
end



hitsMatrix = zeros(1422, 16);

for k=1:1422
    for ch = 1:16
        hits = sum(streamingStruct(3).fileNumber == k & ...
            streamingStruct(3).channel == ch);
        hitsMatrix(k, ch) = hits;
    end
end

channelsToPlot = find(sum(hitsMatrix,1) > 50);
hitsMatrix(hitsMatrix==0) = NaN;
hitsMatrix(isnan(hitsMatrix)) = 0;
plot(hitsMatrix(:,channelsToPlot))
legends = {'Canal 6','Canal 7','Canal 12'};
chs = [6 7 12]
for k=1:3
    figure;
    plot(hitsMatrix(:,chs(k)))
    xlabel('Indice do Arquivo')
    ylabel('Numero de Hits')
    legend(legends{k})
end

for k=channelsToPlot
hold on;
plot(channelsToPlot, hitsMatrix(:,k))
hold off;
end
