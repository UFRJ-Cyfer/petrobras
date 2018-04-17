function verifyPressureBomb(files, channel, path, name, figHandle)

plotRawData = zeros(length(files)*(2^24),length(channel));

for k=1:length(files)
rawData = readStreamingFile([name num2str(files(k),'%03d') '.tdms'], path(k,:));
plotRawData(1+2^24*(k-1):2^24*k,:) = rawData(:,channel);
end

figure(figHandle);
hold off;
plot(plotRawData)
drawnow
title(['Files ' num2str(files(1)) '-' num2str(files(end))])
hold on;
for k=1:length(files)
   plot([(2^24)*k (2^24)*k], [max(max(plotRawData)) -max(max(plotRawData))],'k--')
   drawnow
end
end