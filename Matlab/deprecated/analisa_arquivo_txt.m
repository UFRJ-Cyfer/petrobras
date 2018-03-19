    pathname = 'E:\BACKUPJ\ProjetoPetrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';
    filename = 'idr02_02_ciclo1_1.txt';

    separationIndexes.timeSP = 897;
    separationIndexes.timePI = 1300;
    
cp2TextFile = textDataClass(pathname,filename,2,separationIndexes);

edges = 0:0.005:1;

pathname = 'E:\BACKUPJ\ProjetoPetrobras\IDR02_04_EA Vallen\';
filename = 'IDR02_04_c1.txt';

cp4TextFile_C1 = textDataClass(pathname,filename,4,separationIndexes);
cp4TextFile_C2 = textDataClass(pathname,filename,4,separationIndexes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CP2

tofdCount = zeros(1,8);

for ch = 1:8
%     figure;
%     histogram(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime,edges)
    tofdCount(ch) =  sum(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
end

tofdCount(tofdCount>0) = tofdCount(tofdCount>0)+1;
figure;
bar(tofdCount,'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6)
xlabel('Canal')
ylabel('Quantidade de Ondas de TOFD')
title('CP2')

cp2TextFile.plot();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CP4 Ciclo 1

tofdCount = zeros(1,8);
for ch = 1:8
%     figure;
%     histogram(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime,edges)
    tofdCount(ch) =  sum(cp4TextFile_C1.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
end

tofdCount(tofdCount>0) = tofdCount(tofdCount>0)+1;
figure;
bar(tofdCount,'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6)
xlabel('Canal')
ylabel('Quantidade de Ondas de TOFD')
title('CP4 Ciclo 1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CP4 Ciclo 2
tofdCount = zeros(1,8);
for ch = 1:8
%     figure;
%     histogram(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime,edges)
    tofdCount(ch) =  sum(cp4TextFile_C2.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
end

tofdCount(tofdCount>0) = tofdCount(tofdCount>0)+1;
figure;
bar(tofdCount,'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6)
xlabel('Canal')
ylabel('Quantidade de Ondas de TOFD')
title('CP4 Ciclo 2')


cp2TextFile.plot();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure

tempo = 0:1:size(Vallen,1) - 1;
tempo = tempo/(1e6);

for ch = 1:8
    subplot(3,3,ch);
    channels = cp2TextFile.textStruct.channel;
    channels = channels(1:end-1);
    plot(tempo, mean(Vallen(:,channels == ch),2))
    ylabel('Amplitude')
    xlabel('Tempo (s)')
    title(['Canal ' num2str(ch)])
end


figure

tempo = 0:1:size(IDR02_04_wf2,1) - 1;
tempo = tempo/(2.5e6);

for ch = 1:8
    subplot(3,3,ch);
    channels = cp4TextFile_C1.textStruct.channel;
    channels = channels(1:end-1);
    plot(tempo, mean((10/(2^13*4))*double(IDR02_04_wf2(:,channels == ch)),2))
    ylabel('Amplitude')
    xlabel('Tempo (s)')
    title(['Canal ' num2str(ch)])
end


figure(1);
figure(2);
figure(3);
figure(4);
for ch = 1:8
    
    channelsCP4C1 = cp4TextFile_C1.textStruct.channel;
    channelsCP4C1 = channelsCP4C1(1:end-1);
    
     channelsCP4C2 = cp4TextFile_C2.textStruct.channel;
    channelsCP4C2 = channelsCP4C2(1:end-1);
    
    channelsCP2 = cp2TextFile.textStruct.channel;
    channelsCP2 = channelsCP2(1:end-1);
    
     figure(1)
      hold on;
    bar(ch, sum(channelsCP2==ch),'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6); hold on;

    figure(2)
     hold on;
    bar(ch, sum(channelsCP4C1==ch),'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6); hold on;


    figure(3)
     hold on;
    bar(ch, sum(channelsCP4C2==ch),'FaceColor',[0 0.45 0.74], 'FaceAlpha', 0.6); hold on;
    
    figure(4)
    hold on;
    plot(ch, sum(cp4TextFile_C2.textStruct.deltaTimeStruct(ch).deltaTime == 0.02)/sum(channelsCP4C2==ch),'b.','markers',14); hold on;

end

    figure(1)
    title(['Distribuição Canais CP2'])
    ylabel('Formas de Onda')
    xlabel('Canal')
    
        figure(2)
    title(['Distribuição Canais CP4 Ciclo 1'])
    ylabel('Formas de Onda')
    xlabel('Canal')
    
        figure(3)
    title(['Distribuição Canais CP4 Ciclo 2'])
    ylabel('Formas de Onda')
    xlabel('Canal')
    
    figure(4)
    title(['Proporção TOFD CP4 Ciclo 2'])
    ylabel('Proporção TOFD pelo Total de Ondas')
    xlabel('Canal')
    
    
    
    
    tofdCountCP2 = zeros(1,8);
    tofdCountCP4C1 = zeros(1,8);
    tofdCountCP4C2 = zeros(1,8);

for ch = 1:8
%     figure;
%     histogram(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime,edges)
    tofdCountCP2(ch) =  sum(cp2TextFile.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
    tofdCountCP4C1(ch) =  sum(cp4TextFile_C1.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
    tofdCountCP4C2(ch) =  sum(cp4TextFile_C2.textStruct.deltaTimeStruct(ch).deltaTime == 0.02);
end

sum(tofdCountCP2)
sum(tofdCountCP4C1)
sum(tofdCountCP4C2)


    


caloba_table = [count_channel_sp;count_channel_pe;count_channel_pi]';
caloba_table = [caloba_table sum(caloba_table,2)];

figure;
data_mean = zeros(1,8);
data_std = data_mean;
for k=1:8
    data_wave_channel = Vallen(:, channels_clean ==k);
    
    data_wave_channel = reshape(data_wave_channel, 1, size(data_wave_channel,1)*size(data_wave_channel,2));
    
    data_mean(k) = mean(data_wave_channel);
    data_std(k) = mean(data_wave_channel);
    figure;
    histogram(data_wave_channel);
    
end

figure
errorbar(1:8,data_mean,2*data_std)



savepath = 'E:\BACKUPJ\ProjetoPetrobras\Relatorios\Relatorio Petrobras\images\';

ah = findobj('Type','figure'); % get all figures
for m=1:numel(ah) % go over all axes
    set(findall(ah(m),'-property','FontSize'),'FontSize',12)
    axes_handle = findobj(ah(m),'type','axes');
    ylabel_handle = get(axes_handle,'ylabel');
    
      saveas(ah(m),[savepath ylabel_handle.String ' ' axes_handle.Title.String '.png'])
    %    saveas(ah(m),['nn_output' '.png'])
end


