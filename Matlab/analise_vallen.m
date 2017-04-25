filename = 'idr02_02_ciclo1_1.txt';
pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';
load('Idr02_02_ciclo1_1.mat', 'Vallen')

replaceinfile(',', '.', [pathname,filename])
temp = importdata([pathname,filename], ' ', 4);

Holder = temp.data;
Holder = Holder(1:end-1,:);

t=temp.textdata(5:end-1);
[Y, M, D, H, MN, S] = datevec(t,'HH:MM:SS');

tempo_vallen = H*3600+MN*60+S;

Holder = [Holder tempo_vallen];
Holder(:,1) = Holder(:,1)/1000 + Holder(:,end);
Holder = Holder(:,1:end-1);
cleanHolder = Holder(~any(isnan(Holder),2),:);

%cada coluna é uma fft de cada forma de onda
%Vallen = log10(abs(Vallen)+1e-9);
fft_vallen = fft(Vallen);

%escolha da waveform
Wave = 1;

for Wave = [204 230 854 885 1188 1218]

%% Mag Calc
P2 = abs(fft_vallen/length(fft_vallen));
P1 = P2(1:length(fft_vallen)/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
Fs = 1e6;
f = Fs*(0:(length(fft_vallen)/2))/length(fft_vallen);

figure;
plot(f(1:7000),P1(1:7000,Wave))
title('Single-Sided Amplitude Spectrum of H(t)')
xlabel('f (Hz)')
ylabel('|H(f)|')

%% Phase Calc
figure;
%phs = angle(fftshift(fft_vallen(:,Wave)));
phs = angle(fft_vallen(:,Wave));
phs = phs(1:length(fft_vallen)/2+1);
coeffMA = ones(1, 100)/100;

phs = filter(coeffMA, 1, phs);
subplot(2,1,1)
plot(f(1:7000),phs(1:7000)/pi)
title('Phase Spectrum of H(t)')
ylabel('Phase (rad/pi)')
ylim([-1 1])

subplot(2,1,2)
plot(f(1:7000),detrend(phs(1:7000))/pi)
title('Phase Spectrum of H(t) DETREND')
xlabel('f (Hz)')
ylabel('Phase (rad/pi)')
ylim([-1 1])

end