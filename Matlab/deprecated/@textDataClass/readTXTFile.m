function [obj] = readTXTFile(obj)

replaceinfile(',', '.', [obj.pathname,obj.filename])
Holder = importdata([obj.pathname obj.filename],' ');
deltaTimeStruct = struct;


channels = Holder.data(:,2);
if obj.CP == 2
    wave_indexes = Holder.data(:,end-1);
end
if obj.CP==4
    wave_indexes = Holder.data(:,end);
end
wave_indexes(isnan(wave_indexes)) = 0;

%Corrigindo o arquivo
wave_indexes(wave_indexes == 1) = 0;
wave_indexes(1) = 1;

channels_clean = channels(wave_indexes ~= 0);
wave_indexes_clean = wave_indexes(wave_indexes ~= 0);

[Y,M,D,H,MN,S] = datevec(Holder.textdata(:,end));
time = H*3600+MN*60+S + Holder.data(:,1)/1000;
timeWave = time(wave_indexes_clean);


uniqueChannels = unique(channels_clean);
for ch = 1:length(uniqueChannels)
    deltaTimeAux = diff(timeWave(channels_clean == uniqueChannels(ch)));
    deltaTimeAux(deltaTimeAux < 0.02*1.1 & deltaTimeAux > 0.02*0.9) = 0.02;
    deltaTimeAux(deltaTimeAux < 1*1.1 & deltaTimeAux > 1*0.9) = 1;
    deltaTimeStruct(uniqueChannels(ch)).deltaTime = deltaTimeAux;
end


obj.textStruct.channel = channels_clean;
obj.textStruct.waveIndexes = wave_indexes_clean;
obj.textStruct.timeWave = timeWave;
obj.textStruct.deltaTimeStruct = deltaTimeStruct;
wave_indexes = Holder.data(:,end);


end