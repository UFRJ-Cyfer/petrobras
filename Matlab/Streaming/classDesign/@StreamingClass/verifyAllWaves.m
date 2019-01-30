function [] = verifyAllWaves(this, indexes, varargin)

if nargin <= 1
  indexes = 1:length(this.Waves);
end
cycle = 1;
f = figure();
for i=indexes
    wave = this.Waves(i);
    waveData = wave.rawData;
    
    if cycle <= length(this.cycleDividers)
        if i >= this.cycleDividers(cycle)
            cycle = cycle+1;
        end
    end
    
    rawDataFile = this.readFile(cycle, wave.file);
    x = 1:length(waveData);
    x = x+double(this.Waves(i).absoluteTriggerIndex)-5000;
    
    figure(f);
    hold off;
    plot(rawDataFile(:,wave.channel))
    hold on;
    plot(x, waveData)
    plot(wave.threshold*1*ones(size(rawDataFile(:,wave.channel))), 'k--')
    plot(wave.threshold*-1*ones(size(rawDataFile(:,wave.channel))), 'k--')
    title(['Wave ' num2str(i) ' File ' num2str(wave.file)])
    num2str(i)
    pause;
    
end


end