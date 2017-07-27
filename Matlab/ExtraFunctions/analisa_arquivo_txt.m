 pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';
 filename = 'idr02_02_ciclo1_1.txt';

%pathname = 'H:\BitBucket\Projeto Petrobras\IDR02_04_EA Vallen\';
%filename = 'IDR02_ciclo2.txt';

Holder = importdata([filename],' ');
channels = Holder.data(:,2);


wave_indexes = Holder.data(:,9);
%wave_indexes = Holder.data(:,3);
wave_indexes(isnan(wave_indexes)) = 0;

%Corrigindo o arquivo
 wave_indexes(wave_indexes == 1) = 0;
 wave_indexes(1) = 1;

channels_clean = channels(wave_indexes ~= 0);
wave_indexes_clean = wave_indexes(wave_indexes ~= 0);

figure;
histogram(channels_clean);
xlabel('Canal')
ylabel('N de Ocorrências')

figure;
title('CP2')
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
legend('SP', 'PE', 'PI', 'Location', 'northoutside', 'Orientation','horizontal')
xlabel('Índice da Onda')
ylabel('Canal')
ylim([0 9])

figure;
bins = 0:8;
edges = bins+0.5;

[count_channel_sp, ~] = histcounts(channels_clean(wave_indexes_clean <= time_sp),edges);
[count_channel_pe, ~] = histcounts(channels_clean(aux),edges);
[count_channel_pi, ~] = histcounts(channels_clean(wave_indexes_clean >= time_pi),edges);

bar(bins(2:end), [count_channel_sp;count_channel_pe;count_channel_pi]')
legend('SP', 'PE', 'PI')
xlabel('Canal')
ylabel('N de Ocorrências')

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



ah = findobj('Type','figure'); % get all figures
for m=1:numel(ah) % go over all axes
  set(findall(ah(m),'-property','FontSize'),'FontSize',14)
  axes_handle = findobj(ah(m),'type','axes');
  ylabel_handle = get(axes_handle,'ylabel');
%   saveas(ah(m),[ylabel_handle.String '.png'])
%    saveas(ah(m),['nn_output' '.png'])
end