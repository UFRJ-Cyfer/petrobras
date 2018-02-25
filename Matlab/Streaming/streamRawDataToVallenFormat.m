function [mainVallen] = streamRawDataToVallenFormat(rawData, separationIndexes)
Fs = 2.5e6;
mainVallen.timeDataRaw = (10/(2^13*4))*double(rawData);

mainVallen.timeDataRaw = mainVallen.timeDataRaw - repmat(mean(mainVallen.timeDataRaw,1), size(mainVallen.timeDataRaw,1), 1);

% Auxiliary Vectors (Frequency & Time)
f = Fs*(0:(size(mainVallen.timeDataRaw,1)/2))/size(mainVallen.timeDataRaw,1);
tempo = 1:size(mainVallen.timeDataRaw,1);
tempo = tempo/Fs;


% Computing Single Side Spectrum
fft_vallen = fft(mainVallen.timeDataRaw);
P2 = abs(fft_vallen/size(fft_vallen,1));
P1 = P2(1:size(fft_vallen,1)/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
absoluteFFT = P1;

clear P1 P2



% Calculating Energy from the Single Sided Spectrum

E = zeros(size(absoluteFFT));
E_not_norm = absoluteFFT.^2;
E_T = sum(E_not_norm,1);
E = E_not_norm./repmat(E_T,size(E,1),1);

% Phase calculation

% P = angle(fftshift(fft_vallen));
% P = angle(fft_vallen);
% P = P/pi;
% P = P(1:size(P,1)/2+1,:);
P = 0;


% Codifying targets - Regular

% classes = ones(1,size(fft_vallen,2));

%SP -1
%PE 0
%PI 1
% classes(:,1:time_sp) = -1;
% classes(:,time_sp+1:time_pi) = 0;
% classes(:,time_pi+1:end) = 1;
% classes = repmat(classes,size(E,2),1);


% Codifying targets - Sparse
% output_classes = classes(:,1);
y_classes = zeros(3,size(mainVallen.timeDataRaw,2));
y_classes(:,1:separationIndexes.timeSP) = repmat([1; 0; 0],1,separationIndexes.timeSP);
y_classes(:,separationIndexes.timeSP+1:separationIndexes.timePI) = repmat([0; 1; 0],1,separationIndexes.timePI-separationIndexes.timeSP);
y_classes(:,separationIndexes.timePI+1:end) = repmat([0; 0; 1],1,size(y_classes(:,separationIndexes.timePI+1:end),2));




% Output Assigments

% mainVallen.timeDataRaw = VallenRaw;
mainVallen.timeDataClean = mainVallen.timeDataRaw ;
% mainVallen.fftDataRaw = fft_vallen;
% mainVallen.waveIndexes = wave_indexes;
% mainVallen.phase = P;
mainVallen.energy = E_not_norm;
mainVallen.normalizedEnergy = E;
mainVallen.timeVector = tempo;
mainVallen.frequencyVector = f;
mainVallen.totalEnergy = E_T;
mainVallen.separationIndexes = separationIndexes;
mainVallen.sparseCodification = y_classes;
% mainVallen.regularCodification = classes;
% mainVallen.waveIndexesNewAndOld = waveIndexesNewAndOld;
% mainVallen.wavesToKeep = wavesToKeep;

end