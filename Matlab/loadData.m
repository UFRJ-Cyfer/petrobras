function mainVallen = loadData(filename, timeWindow, minAcceptableAmplitude, separationIndexes, PIRemainsIndex)

load(filename, 'Vallen');

% Time Windowing / Weird samples (after PI) removal
Vallen = Vallen(1:timeWindow,1:PIRemainsIndex);
VallenRaw = Vallen;

max_vallen = max(Vallen);
wave_indexes = 1:size(Vallen,2);

Vallen = Vallen(:, max_vallen > minAcceptableAmplitude);
wave_indexes = wave_indexes(max_vallen > minAcceptableAmplitude);

% Auxiliary Vectors (Frequency & Time)
Fs = 1e6;
f = Fs*(0:(size(Vallen,1)/2))/size(Vallen,1);
tempo = 1:size(Vallen,1);
tempo = tempo/Fs;


% Computing Single Side Spectrum
fft_vallen = fft(Vallen);
P2 = abs(fft_vallen/size(fft_vallen,1));
P1 = P2(1:size(fft_vallen,1)/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
absoluteFFT = P1;

% Recalculating the Classes Separation Indexes
time_sp = separationIndexes.indexSP;
time_pi = separationIndexes.indexPI;
[~, I_sep] = find(wave_indexes >= time_sp);
time_sp = (I_sep(1));
[~, I_sep] = find(wave_indexes >= time_pi);
time_pi = (I_sep(1));


% Calculating Energy from the Single Sided Spectrum

E = zeros(size(absoluteFFT));
E_not_norm = absoluteFFT.^2;
E_T = sum(E_not_norm,1);
E = E_not_norm./repmat(E_T,size(E,1),1);

% Phase calculation

% P = angle(fftshift(fft_vallen));
P = angle(fft_vallen);
P = P/pi;
P = P(1:size(P,1)/2+1,:);


% Codifying targets - Regular

classes = ones(1,size(fft_vallen,2));

%SP -1
%PE 0
%PI 1
classes(:,1:time_sp) = -1;
classes(:,time_sp+1:time_pi) = 0;
classes(:,time_pi+1:end) = 1;
classes = repmat(classes,size(E,2),1);


% Codifying targets - Sparse
output_classes = classes(:,1);
y_classes = repmat(output_classes',3,1);
y_classes(:,1:time_sp) = repmat([1; 0; 0],1,time_sp);
y_classes(:,time_sp+1:time_pi) = repmat([0; 1; 0],1,time_pi-time_sp);
y_classes(:,time_pi+1:end) = repmat([0; 0; 1],1,size(y_classes(:,time_pi+1:end),2));




% Output Assigments

mainVallen.timeDataRaw = VallenRaw;
mainVallen.timeDataClean = Vallen;
mainVallen.fftDataRaw = fft_vallen;
mainVallen.waveIndexes = wave_indexes;
mainVallen.phase = P;
mainVallen.energy = E_not_norm;
mainVallen.normalizedEnergy = E;
mainVallen.timeVector = tempo;
mainVallen.frequencyVector = f;
mainVallen.totalEnergy = E_T;
mainVallen.separationIndexes.timeSP = time_sp;
mainVallen.separationIndexes.timePI = time_pi;
mainVallen.sparseCodification = y_classes;
mainVallen.regularCodification = classes;



end