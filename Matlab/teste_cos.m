tempo = linspace(0, 10, 1024);
y = cos(10*2*pi*tempo);
fft_cos = fft(y);
figure
stem(abs(fft_cos))

P2 = abs(fft_cos/length(fft_cos));
P1 = P2(1:length(fft_cos)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
Fs = 1/(tempo(2)-tempo(1));
f = Fs*(0:(length(fft_cos)/2))/length(fft_cos);

figure;
plot(f,P1)
title('Single-Sided Amplitude Spectrum of H(t)')
xlabel('f (Hz)')
ylabel('|H(f)|')

figure;
phs = angle(fft_cos(:));
phs = phs(1:length(fft_cos)/2+1);

plot(f,phs/pi)
title('Phase Spectrum of H(t)')
ylabel('Phase (rad/pi)')
xlabel('f (Hz)')
ylim([-1 1])

