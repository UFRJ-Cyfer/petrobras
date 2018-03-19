figure;
timeVector = 0:42499;
timeVector = timeVector*4e-7;
indexes = 1:41473;

indexes = indexes(streamingStruct(4).channel~=8);


for l=1:20:201
    k = indexes(l);
    plot(timeVector, streamingStruct(4).rawData(:,k))
    grid on;
    xlabel('Tempo (s)')
    title(['CP4-' num2str(streamingStruct(4).startingTime(k)) '-channel-' num2str(streamingStruct(4).channel(k))])
    saveas(gcf,['Reunioes/images/CP4/CP4_Channel_' num2str(streamingStruct(4).channel(k)) '_' num2str(k) '.png'])
end

figure;
plot(streamingStruct(1).startingTime, streamingStruct(1).channel,  '.')
xlabel('Tempo(s)')
ylabel('Canal')
grid on;
saveas(gcf,['Reunioes/images/CP2/distribuicaoTempo.png'])


[ cleanedStructCP4, structDTCP4, tofdIndexesCP4 ] = removeTOFD( streamingStruct );


figure;
edges = 0:0.01:1;
for CP = [1 3 4]
    for channel=1:16
        subplot(4,4,channel)
        histogram(diff(cleanedStruct(CP).startingTime(cleanedStruct(CP).channel == channel)),edges)
        title(['Canal ' num2str(channel)])
    end
    saveas(gcf,['Reunioes/images/histogramDeltaT_Reduced_CP' num2str(CP) '.png'])
end


figure;
edges = 0:0.01:1;
for CP = [1 3 4]
    for channel=1:16
        subplot(4,4,channel)
        histogram(diff(streamingStructMain(CP).startingTime(streamingStructMain(CP).channel == channel)),edges)
        title(['Canal ' num2str(channel)])
    end
    saveas(gcf,['Reunioes/images/histogramDeltaT_Normal_CP' num2str(CP) '.png'])
end

figure;
imagesc(numBitsFileChannel')
colorbar
caxis([4 14])
xlabel('Arquivo TDMS')
ylabel('Canal')
saveas(gcf,['Reunioes/images/colorBitsCP4Ciclo1.png'])

figure;
titlesForPlot = {'CP2', ' ','CP3', 'CP4 Ciclo 2'};
for CP = [1 3 4]
    histogram((streamingStructMain(CP).channel))
    title(titlesForPlot{CP})
    set(gca,'YScale','log')
    xlim([0 17])
    
    saveas(gcf,['Reunioes/images/histogramChannel_Normal_' titlesForPlot{CP} '.png'])
end

figure;
for CP = [1 3 4]
    histogram((cleanedStruct(CP).channel))
    title(titlesForPlot{CP})
    set(gca,'YScale','log')
    xlabel('Canal')
    ylabel('Quantidade de Formas de Onda Capturadas')
    xlim([0 17])
    
    saveas(gcf,['Reunioes/images/histogramChannel_Reduced' titlesForPlot{CP} '.png'])
end


 histogram((cleanedStructCP4(5).channel))
    title('CP4 Ciclo 1')
    set(gca,'YScale','log')
    xlabel('Canal')
    ylabel('Quantidade de Formas de Onda Capturadas')
    xlim([0 17])
    saveas(gcf,['Reunioes/images/histogramCP4_Ciclo1' '.png'])

figure;
vetorTempoStreaming = 0:1:42500-1;
vetorTempoStreaming = vetorTempoStreaming*4e-7;
plot(vetorTempoStreaming,mean(cleanedStruct(4).rawData(:,cleanedStruct(4).channel==8),2))
title('Sinal Médio Canal 8')
xlabel('Tempo (s)')
ylabel('Amplitude')
saveas(gcf,['Reunioes/images/meanSignalEq8CP4Ciclo2'  '.png'])

figure;
vetorTempoStreaming = 0:1:42500-1;
vetorTempoStreaming = vetorTempoStreaming*4e-7;
plot(vetorTempoStreaming,mean(cleanedStructCP4(5).rawData(:,cleanedStructCP4(5).channel==8),2))
title('Sinal Médio Canal 8')
xlabel('Tempo (s)')
ylabel('Amplitude')
saveas(gcf,['Reunioes/images/meanSignalEq8CP4Ciclo1'  '.png'])


figure;
plot(vetorTempoStreaming,mean(cleanedStruct(4).rawData(:,cleanedStruct(4).channel~=8),2))
title('Sinal Médio Restantes Canais')
xlabel('Tempo (s)')
ylabel('Amplitude')
saveas(gcf,['Reunioes/images/meanSignalDiff8CP4Ciclo2' titlesForPlot{CP} '.png'])

figure;
for channel=1:16
    subplot(4,4,channel)
    plot(vetorTempoStreaming, mean(cleanedStruct(3).rawData(:,cleanedStruct(3).channel == channel),2));
    title(['Canal ' num2str(channel)])
    if channel == 1 ||channel == 5 ||channel == 9||channel == 13
       ylabel('Amplitude') 
    end
    
        if channel == 13 ||channel == 14||channel == 15||channel == 16
       xlabel('Tempo (s)') 
    end
end
saveas(gcf,['Reunioes/images/meanSignalPerChannelCP3' '.png'])