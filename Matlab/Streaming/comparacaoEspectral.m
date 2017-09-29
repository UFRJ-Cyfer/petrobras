for k=1:size(rawData,2)
    figure;
    plot(rawData(:,k),'.')
end


 events = [8.396e5+1.3e5 1.569e6 1.127e6+5.5e5 2.093e6 1.463e6+2.1e5+0.3e5 2.001e6];
 
    downsamplingScale = 1;
    i__ = [13 12 11]
    
    
    k__=1; for i = i__

    k = k__;
tempo = 1:length(rawData(:,i));
tempo = tempo/fs;

% Y = fft(rawData(events(k):downsamplingScale:events(k)+65536*2.5,i) - mean(rawData(events(k):downsamplingScale:events(k)+65536*2.5,i)));
Y = fft(filteredNewMA(events(k):downsamplingScale:events(k)+65536*2.5,i+1) - mean(filteredNewMA(events(k):downsamplingScale:events(k)+65536*2.5,i+1)));
L = length(filteredNewMA(events(k):downsamplingScale:events(k)+65536*2.5,i+1));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

fs = 2.5e6;
% P1 = P1.^2/sum(P1.^2);
f = fs*(0:(L/2))/L;

aux = find(f>=5e5);


figure
plot(f(1:aux(1)-1),P1(2:aux(1)))
title(['FFT channel' num2str(i)])
xlabel('frequency (Hz)')
% ylabel('Energia Normalizada')
ylabel('|H(f)|')


figure
plot(tempo(events(k):downsamplingScale:events(k)+65536*2.5) - tempo(events(k)), filteredNewMA(events(k):downsamplingScale:events(k)+65536*2.5,i+1) - mean(filteredNewMA(events(k):downsamplingScale:events(k)+65536*2.5,i+1))) 
title(['channel' num2str(i)])
xlabel('Tempo (s)')
k__ = k__+2;
end


Y = mainVallen.timeDataClean(:,300);
L = length(Y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
fs = 1e6;
f = fs*(0:(L/2))/L;
% P1 = P1.^2/sum(P1.^2);


figure
plot(f(1:end),P1(1:end)) 
title('FFT Vallen')
xlabel('Frequency (Hz)')
% ylabel('Energia Normalizada')
ylabel('|H(f)|')

figure
tempo = 1:length(Y);
tempo = tempo/fs;
plot(tempo,Y)
xlabel('Tempo (s)')
cutOffFreqeuncy = 75e3;

[ vallenFiltrado ] = filterStreaming( mainVallen.timeDataClean(:,300), fs, cutOffFreqeuncy, 0)



Y = vallenFiltrado(:,2);
L = length(Y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
fs = 1e6;
f = fs*(0:(L/2))/L;
% P1 = P1.^2/sum(P1.^2);


figure
plot(f(1:end),P1(1:end)) 
title('FFT Vallen Filtrado')
xlabel('Frequency (Hz)')
% ylabel('Energia Normalizada')
ylabel('|H(f)|')

figure
tempo = 1:length(Y);
tempo = tempo/fs;
plot(tempo,Y)
xlabel('Tempo (s)')
title('Sinal Vallen Filtrado')