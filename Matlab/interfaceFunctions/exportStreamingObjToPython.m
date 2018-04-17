function outputStruct = exportStreamingObjToPython(streamingObj)

    wavesStruct = struct();
    for k=flip(1:length(streamingObj.Waves))
        wavesStruct(k).wave = struct(streamingObj.Waves(1,k));        
    end
    outputStruct = struct(streamingObj);
    outputStruct.Waves = [];
    
    save('structStreamingObj.mat','outputStruct','wavesStruct')


end