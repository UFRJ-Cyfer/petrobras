pathname = 'E:\BACKUPJ\ProjetoPetrobras\IDR02_04_EA Vallen\';
filename = 'IDR02_04_c2.txt';
   
replaceinfile(',', '.', [pathname,filename])

Holder = importdata([pathname filename],' ');

channels = Holder.data(:,1);
wave_indexes = Holder.data(:,3);

channels_clean = channels(~isnan(wave_indexes));
wave_indexes_clean = wave_indexes(~isnan(wave_indexes));

figure;
histogram(channels_clean);
xlabel('Canal')
ylabel('N de Ocorrências')

figure;
title('CP4')
plot(wave_indexes_clean, channels_clean, '.')
xlabel('Índice da Onda')
ylabel('Canal')
ylim([0 9])

aux = (wave_indexes_clean >= time_sp) & (wave_indexes_clean <= time_pi);

time_sp = 897;
time_pi = 1300;

figure;
hold on;
plot(wave_indexes_clean(wave_indexes_clean <= time_sp), channels_clean(wave_indexes_clean <= time_sp), 'r.')
plot(wave_indexes_clean(aux), channels_clean(aux), 'g.')
plot(wave_indexes_clean(wave_indexes_clean >= time_pi), channels_clean(wave_indexes_clean >= time_pi), 'b.')
ylim([0 9])

figure;
bins = 0:8;
edges = bins+0.5;

[count_channel_sp, ~] = histcounts(channels_clean(wave_indexes_clean <= time_sp),edges);
[count_channel_pe, ~] = histcounts(channels_clean(aux),edges);
[count_channel_pi, ~] = histcounts(channels_clean(wave_indexes_clean >= time_pi),edges);

bar(bins(2:end), [count_channel_sp;count_channel_pe;count_channel_pi]')
legend('SP', 'PE', 'PI')

caloba_table = [count_channel_sp;count_channel_pe;count_channel_pi]';
caloba_table = [caloba_table sum(caloba_table,2)];
