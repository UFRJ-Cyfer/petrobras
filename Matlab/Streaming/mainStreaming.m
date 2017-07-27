fs = 2.5e6; % streaming sampling frequency (Hz)
f = 10e3; % low pass cutoff frequency (Hz)

%converter


%filtering
filteredNewMA = filterStreaming(Draw, fs, f);

for k=1:size(filtered,2)
   figure;
   plot(filteredNew(:,k))
   title(['canal' num2str(k)])    
end

   figure;
   plot(filtered(:,3))
   
   
   figure;
   plot(filteredNew(:,3))
   
      figure;
   plot(filteredNewMA(:,3))

%identifying waves

waves = identifyWaves(filteredData);


%saving struct