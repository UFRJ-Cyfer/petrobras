function this = createFrequencyData(this, fs)
rawDataCell = this.propertyVector('rawData');
freqSlots = linspace(0, fs/2, 2^11);
this.freqSlots = freqSlots;
disp('Calculating FFT for each wave')

N = 2^16;
fftWaves = zeros(N/2, length(rawDataCell));
for k=1:length(rawDataCell)
    wave = double(rawDataCell{k});
    wave = wave(1:end-2500); %removing HLT
    wave = wave - mean(wave);
    fftWave = fft(wave,N)/length(wave);
    %    there is no problem multiplying by 2 here since H(0) = 0
    fftWave = 2*fftWave(1:(length(fftWave) - mod(length(fftWave),2))/2);
    fftWaves(:,k) = fftWave;
end

outputAbs = abs(fftWaves);
outputPhase = angle(fftWaves);

P = zeros(size(outputAbs));
P_not_norm = outputAbs.^2;
P_T = sum(P_not_norm,1);
P = P_not_norm./repmat(P_T,size(P,1),1);

this.normalizedPower = P;
this.power = P_not_norm;
this.phase = outputPhase;
this.frequencyArray = linspace(0, fs/2, size(outputAbs,1));
this.StreamingModel.frequencyArray = this.frequencyArray;


end