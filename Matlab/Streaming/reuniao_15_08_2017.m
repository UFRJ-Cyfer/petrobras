load('bitsPerChannelCP4.mat')

filesToOpen = numBitsFileChannel >= 10;
fileVector = 1:1500;
fs = 2.5e6;
v = (10/(2^13*4));%fator de conversao de valor binario para volts


for channel = 4
for fileNumber = fileVector(filesToOpen(:,channel))
    filename = ['ciclo_2#' num2str(fileNumber,'%03d') '.tdms'];
    path = 'M:\CP4-24.05.2016\Ciclo2-1de1';       
    rawData = readStreamingFile_( filename, path );
    tempo = 1/fs*(1:size(rawData,1));
    
    figure;
    plot(tempo, v*double(rawData(:,channel)),'.')
    xlabel('tempo (s)')
    ylabel('tensao (V)')
    title(['Arquivo ' num2str(fileNumber) ' Canal ' num2str(channel)])
end
end