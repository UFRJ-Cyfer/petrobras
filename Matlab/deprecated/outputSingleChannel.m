    files = {'idr2_02_ciclo_1#','idr2_02_ciclo_1_2#','idr2_02_ciclo_1_3#',...
        'IDR2_ensaio_03#','ciclo_2#','testeFAlta#','testeFAlta#'};
    
    paths = {'J:\EnsaioIDR02-2\SegundoTuboStreaming', 'J:\EnsaioIDR02-2\SegundoTuboStreaming', 'J:\EnsaioIDR02-2\SegundoTuboStreaming',...
        'N:\CP3\Ciclo1','M:\CP4-24.05.2016\Ciclo2-1de1','M:\CP4-24.05.2016\Ciclo1-1de1','L:\CP4-24.05.2016\Ciclo1-2de2'};
    
    desc = {'CP2_ciclo_1_1', 'CP2_ciclo_1_2', 'CP2_ciclo_1_3',...
        'CP3_Ciclo_1','CP4_Ciclo_2','CP4_Ciclo_1_1','CP4_Ciclo_1_2'};
    
    numberOfFiles = 150;
    
    filesToCheck = 1051:1500;
    chanel = 12;
    
    for k=4

for fileNumber = filesToCheck
     filename = [files{k} num2str(fileNumber,'%03d') '.tdms'];
    %converter
    
    rawData = readStreamingFile( filename, paths{k} );
    
    extratedChannel = rawData(:,chanel);
    save(['extractedChannel/chanel' num2str(chanel) 'Extracted' num2str(fileNumber) 'CP3'],'extratedChannel','-v7.3')
end
    end
    
    cp3RawData = double(cp3RawData);
    
    
    for k=1:size(cp3RawData,2)
        cp3RawData(:,k) = cp3RawData(:,k) - mean(cp3RawData(:,k));
    end
    
    cp3RawData = cp3RawData * (10/(2^13*4));