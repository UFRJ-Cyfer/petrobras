function this = createFrequencyData(this, fs)
%Calculates FFT of N points for all waves. Used to calculate normalizedPower, power, phase and frequencyArray.
%
% :param fs: Sampling Frequency, normally 2.5Ghz.
% :type fs: double
%
% :returns: StreamingClass object with normalizedPower, power, phase, and frequencyArray calculated.
%

rawDataCell = this.propertyVector('rawData');
freqSlots = linspace(0, fs/2, 2^11);
this.freqSlots = freqSlots;
disp('Calculating FFT for each wave')

N = 2^16;
fftWaves = zeros(N, length(rawDataCell));
for k=1:length(rawDataCell)
    wave = double(rawDataCell{k});
    wave = wave(1:end-2500); %removing HLT
    wave = wave - mean(wave);
    fftWave = fft(wave,N)/length(wave);
    
    %    there is no problem multiplying by 2 here since H(0) = 0
  %  fftWave = 2*fftWave(1:(length(fftWave) - mod(length(fftWave),2))/2);
    fftWaves(:,k) = fftWave;
end

outputAbs = abs(fftWaves);
outputAbs = outputAbs(1:N/2+1,:);
outputAbs(2:end-1,:) = 2*outputAbs(2:end-1,:);

outputPhase = angle(fftWaves);
outputPhase = outputPhase(1:N/2+1,:);


P = zeros(size(outputAbs));
P_not_norm = outputAbs.^2;
P_T = sum(P_not_norm,1);
P = P_not_norm./repmat(P_T,size(P,1),1);

this.normalizedPower = P;
this.power = P_not_norm;
this.phase = outputPhase;
this.frequencyArray = fs*(0:(N/2))/N;
this.StreamingModel.frequencyArray = this.frequencyArray;


end