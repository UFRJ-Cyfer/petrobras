% for k_=1:1500
%    count(k_) = sum(streamingStruct(3).fileNumber == k_);
% end
% 
% chosenFilesToPlot = find(count > 100);
tempo = 0:2^24-1;
tempo = tempo/(2.5e6);

for m = [256:288]
    rawData = readStreamingFile( ['IDR2_ensaio_03#' num2str(m,'%03d') '.tdms'], paths{k} );
    
    figure(8)
    plot(tempo,rawData(:,7))
    xlabel('Tempo (s)')
    ylabel('Amplitude')
    title(['Arquivo ' num2str(m,'%03d') ' Canal 7'])

    figure(9)
    plot(tempo,rawData(:,12))
    xlabel('Tempo (s)')
    ylabel('Amplitude')
    title(['Arquivo ' num2str(m,'%03d') ' Canal 12'])
    saveAllFigures;

end
% 
% indexesToRemove = find(streamingStruct(3).fileNumber <= 236);
% 
% streamingStruct(3).rawData(:,indexesToRemove) = [];
% streamingStruct(3).channel(:,indexesToRemove) = [];
% streamingStruct(3).resolution(:,indexesToRemove) = [];
% streamingStruct(3).startingTime(:,indexesToRemove) = [];
% streamingStruct(3).triggerTime(:,indexesToRemove) = [];
% streamingStruct(3).fileNumber(:,indexesToRemove) = [];


 files_logFileTranscript = [1 63 130 236 347 448 555 647 769 864 938 1030 1119 1211 1293 1384 1421];
 
 pressure = [0 0 100 100 130 130 156 156 182 182 208 208 234 234 260 260 275];