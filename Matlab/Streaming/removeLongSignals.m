
explosionFile = [0, 1422, 0, 0];
cpIdentifier = regexp(streamingStruct,'\d*','Match');
 
indexLastFileBeforeExplosion = find(streamingStruct(3).fileNumber == 1422,1)-1;

indexesToRemoveNoise = [];
for l_ = 1:indexLastFileBeforeExplosion
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
    
    indexesToRemoveExplosion = find(streamingStruct(3).fileNumber >1422); 
    
    streamingStruct(3).rawData(:,indexesToRemoveExplosion) = [];
    streamingStruct(3).channel(:,indexesToRemoveExplosion) = [];
    streamingStruct(3).resolution(:,indexesToRemoveExplosion) = [];
    streamingStruct(3).startingTime(:,indexesToRemoveExplosion) = [];
    streamingStruct(3).triggerTime(:,indexesToRemoveExplosion) = [];
    streamingStruct(3).fileNumber(:,indexesToRemoveExplosion) = [];