function [ figHandle ] = plot( obj )
%PLOT Summary of this function goes here
%   Detailed explanation goes here
textStruct = obj.textStruct;

CPString = ['CP' num2str(obj.CP)];
figure;
histogram(textStruct.channel);
xlabel('Canal')
ylabel('N de Ocorrências')
title(['Histograma de Canais ' CPString])


figure;
title(CPString)
plot(textStruct.timeWave, textStruct.channel, '.')
xlabel('Tempo (s)')
ylabel('Canal')
ylim([0 9])

timeSP = obj.separationIndexes.timeSP;
timePI = obj.separationIndexes.timePI;

aux = (textStruct.waveIndexes >= timeSP) & (textStruct.waveIndexes <= timePI);

timeSP = 897;
timePI = 1300;

figure;
hold on;
plot(textStruct.timeWave(textStruct.waveIndexes <= timeSP), ...
    textStruct.channel(textStruct.waveIndexes <= timeSP), 'r.')

plot(textStruct.timeWave(aux), ...
    textStruct.channel(aux), 'g.')

plot(textStruct.timeWave(textStruct.waveIndexes >= timePI), ...
    textStruct.channel(textStruct.waveIndexes >= timePI), 'b.')

legend('SP', 'PE', 'PI', 'Location', 'northoutside', 'Orientation','horizontal')
xlabel('Tempo (s)')
ylabel('Canal')
ylim([0 9])

figure;
bins = 0:8;
edges = bins+0.5;

[count_channel_sp, ~] = histcounts(textStruct.channel(textStruct.waveIndexes <= timeSP),edges);
[count_channel_pe, ~] = histcounts(textStruct.channel(aux),edges);
[count_channel_pi, ~] = histcounts(textStruct.channel(textStruct.waveIndexes >= timePI),edges);

bar(bins(2:end), [count_channel_sp;count_channel_pe;count_channel_pi]')
legend('SP', 'PE', 'PI')
xlabel('Canal')
ylabel('N de Ocorrências')

figure;
histogram(textStruct.deltaTime);
TOFDIndexes = (textStruct.deltaTime==0.02);

figure;
title(['All Waves ' CPString])
plot(textStruct.timeWave, textStruct.channel, 'b.'); hold on;
plot(textStruct.timeWave(TOFDIndexes), textStruct.channel(TOFDIndexes), 'k.');
xlabel('Tempo (s)')
ylabel('Canal')
ylim([0 9])

figure;
title(['TOFD Waves ' CPString])
plot(textStruct.timeWave(TOFDIndexes), textStruct.channel(TOFDIndexes), 'k.');
xlabel('Tempo (s)')
ylabel('Canal')
ylim([0 9])


end

