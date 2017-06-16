
data_mean = zeros(1,8);
data_std = data_mean;

for k=1:8
   data_wave_channel = Vallen(:, channels_clean ==k);
   
   data_wave_channel = reshape(data_wave_channel, 1, size(data_wave_channel,1)*size(data_wave_channel,2));
   
   data_mean(k) = mean(data_wave_channel);
   data_std(k) = mean(data_wave_channel);
   figure;
   histogram(data_wave_channel,100);
   set(gca, 'YScale', 'log')

end

errorbar(1:8,data_mean,2*data_std)


wave_transform = [];
for k=1:1663
 wave_transform(k,:) = cwt(Vallen(:,k),100,'sym2');
end

figure
plot(wave_transform(1:time_sp,:))
figure
plot(wave_transform(time_sp:time_pi,:))
figure
plot(wave_transform(time_pi:end,:))
