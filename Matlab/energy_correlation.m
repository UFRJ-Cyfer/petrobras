filename = 'idr02_02_ciclo1_1.txt';
pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';
load('Idr02_02_ciclo1_1.mat', 'Vallen')
Fs = 1e6;

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

%janelamento
time_window = 1.8e4;
Vallen = Vallen(1:time_window,:);

%cada coluna é uma fft de cada forma de onda
%Vallen = log10(abs(Vallen)+1e-9);
fft_vallen = fft(Vallen);
f = Fs*(0:(length(fft_vallen)/2))/length(fft_vallen);

time_sp = 897;
time_pi = 1128;

%clean_fft_vallen = fft_vallen((f > 1.8e4 & f < 7e4),:);

%clean_fft_vallen = clean_fft_vallen(1:3400,:);

E = zeros(34,size(clean_fft_vallen,2));

for k=1:68
  % E(k,:) = trapz(abs(clean_fft_vallen(50*(k-1)+1:50*k,:)).^2);
%    E(k,:) = (E(k,:)-mean(E(k,:)))/std(E(k,:));
end

 E = zeros(size(fft_vallen,1),size(fft_vallen,2));
 E = abs(fft_vallen).^2./repmat(sum(abs(fft_vallen).^2),size(E,1),1);
 E = E(1:length(E)/2,:);
 f = Fs*(0:(length(fft_vallen)/2))/length(fft_vallen);
 f = f(1:end-1);

%  E = zeros(size(clean_fft_vallen,1),size(clean_fft_vallen,2));
%  E = abs(clean_fft_vallen).^2;

checker = sum(E,1);
 
classes = ones(1,size(fft_vallen,2));

%SP -1
%PE 0
%PI 1
classes(:,1:time_sp) = -1;
classes(:,time_sp+1:time_pi) = -1;
classes(:,time_pi+1:end) = 1;

classes = repmat(classes,size(E,1),1);

E = E';
classes  = classes';

% E = (E-repmat(mean(E),size(E,1),1))/std(E,1);

% R = sum((classes-repmat(mean(classes),size(classes,1),1)).*...
%     (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(classes),size(classes,1),1) ./ repmat(std(E),size(E,1),1),1);

R = mean((classes-repmat(mean(classes),size(classes,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(classes,1),size(classes,1),1) ./ repmat(std(E,1),size(E,1),1));

freq = 2;
% R_first = [];
% for freq=1:30000
% R_first(freq) = mean((E(:,freq) - mean(E(:,freq),1)).*(classes(:,freq)-mean(classes(:,freq))))...
%     ./std(classes(:,freq),1)./std(E(:,freq),1);
% end

corr_limit = 2/sqrt(size(fft_vallen,2));

figure;
plot(f,R);
hold on;
plot(f,ones(size(R))*corr_limit,'r--')
plot(f,ones(size(R))*corr_limit*-1,'r--')
xlabel('Frequency (Hz)')
% figure;
% plot(R_first);
figure;
coeffMA = ones(1, 30)/30;
plot(f,filter(coeffMA, 1, R));
hold on;
plot(f,ones(size(R))*corr_limit,'r--')
plot(f,ones(size(R))*corr_limit*-1,'r--')
xlabel('Frequency (Hz)')

freq_range_min = 6.6e4;
freq_range_max = 1.82e5;

freq_range_min_ = 2.8e5;
freq_range_max_ = 3.05e5;

E_first = E(:,f>freq_range_min & f < freq_range_max);

E_second = E(:,f>freq_range_min_ & f < freq_range_max_);

E_classify = [E_first E_second];
