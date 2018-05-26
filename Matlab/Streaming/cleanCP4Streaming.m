
%First remove channel 8
indexesChannel8 = streamingObj.propertyVector('channel')==8;
streamingObj.Waves(indexesChannel8) = [];

%Remove waves that were captured after the explosion
streamingObj.Waves(streamingObj.propertyVector('triggerTime') >= (T+5)) = [];
T = streamingObj.Waves(816).triggerTime;


%Manually inspecting and removing waves
rawCell = streamingObj.propertyVector('rawData');
channels = streamingObj.propertyVector('channel');
files = streamingObj.propertyVector('file');

manualRemovedWaves = [];

for k=1:length(rawCell)
   plot(rawCell{k})
   title([num2str(k) 'Canal ' num2str(channels(k)) ' Arquivo ' num2str(files(k))])
   [~,~, button] = ginput(1);
   if button == 3
    manualRemovedWaves = [manualRemovedWaves k];
   end
end
streamingObj.Waves(manualRemovedWaves) = [];

for k=304:length(streamingObj.Waves)
    streamingObj.Waves(k).triggerTime = streamingObj.Waves(k).triggerTime + T;
end

T = streamingObj.Waves(303).triggerTime;