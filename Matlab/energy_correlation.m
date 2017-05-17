% filename = 'idr02_02_ciclo1_1.txt';
% pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';

A = exist('Vallen','var');

if (~A)
load('Idr02_02_ciclo1_1.mat', 'Vallen')
%janelamento
time_window = 1.8e4;
Vallen = Vallen(1:time_window,:);
fft_vallen = fft(Vallen);
end
% 
% replaceinfile(',', '.', [pathname,filename])
% temp = importdata([pathname,filename], ' ', 4);
% 
% Holder = temp.data;
% Holder = Holder(1:end-1,:);
% 
% t=temp.textdata(5:end-1);
% [Y, M, D, H, MN, S] = datevec(t,'HH:MM:SS');
% 
% tempo_vallen = H*3600+MN*60+S;
% 
% Holder = [Holder tempo_vallen];
% Holder(:,1) = Holder(:,1)/1000 + Holder(:,end);
% Holder = Holder(:,1:end-1);
% cleanHolder = Holder(~any(isnan(Holder),2),:);



%cada coluna é uma fft de cada forma de onda
%Vallen = log10(abs(Vallen)+1e-9);
Fs = 1e6;
f = Fs*(0:(length(fft_vallen)/2))/length(fft_vallen);
f = f(1:end-1);
coeffMA = ones(1, 100)/100;


time_sp = 897;
time_pi = 1300;

P = zeros(size(fft_vallen,1),size(fft_vallen,2));
P = angle(fftshift(fft_vallen));
P = P/pi;
P = P(1:length(P)/2,:);
figure;
plot(f,P)
figure;
plot(f,filter(coeffMA, 1, P))

P = filter(coeffMA, 1, P);

 E = zeros(size(fft_vallen,1),size(fft_vallen,2));
%  E = abs(fft_vallen).^2;
 E = abs(fft_vallen).^2./repmat(sum(abs(fft_vallen).^2),size(E,1),1);
 E = E(1:length(E)/2,:);


%  E = zeros(size(clean_fft_vallen,1),size(clean_fft_vallen,2));
%  E = abs(clean_fft_vallen).^2;

checker = sum(E,1);
 
classes = ones(1,size(fft_vallen,2));

%SP -1
%PE 0
%PI 1
classes(:,1:time_sp) = 0;
classes(:,time_sp+1:time_pi) = 0;
classes(:,time_pi+1:end) = 1;

classes = repmat(classes,size(E,1),1);

E = E';
classes  = classes';
P=P';

% E = (E-repmat(mean(E),size(E,1),1))/std(E,1);

% R = sum((classes-repmat(mean(classes),size(classes,1),1)).*...
%     (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(classes),size(classes,1),1) ./ repmat(std(E),size(E,1),1),1);

R = mean((classes-repmat(mean(classes),size(classes,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(classes,1),size(classes,1),1) ./ repmat(std(E,1),size(E,1),1));

R_P = mean((classes-repmat(mean(classes),size(classes,1),1)).*...
    (P-repmat(mean(P),size(P,1),1)) ./ repmat(std(classes,1),size(classes,1),1) ./ repmat(std(P,1),size(P,1),1));

corr_limit = 2/sqrt(size(E,1));

figure;
subplot(2,1,1);
plot(R);
hold on;
plot(ones(size(R))*corr_limit,'r--')
plot(ones(size(R))*corr_limit*-1,'r--')
plot(find(abs(R)>corr_limit),R(abs(R)>corr_limit),'r.');
grid on;

subplot(2,1,2);
plot(R_P);
hold on;
plot(ones(size(R_P))*corr_limit,'r--')
plot(ones(size(R_P))*corr_limit*-1,'r--')
plot(find(abs(R_P)>corr_limit),R_P(abs(R_P)>corr_limit),'r.');
grid on;


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
figure;
plot(f,E');

E_classify = E(:,abs(R)>corr_limit);



NUM_SLOTS = 5;
E_entry = zeros(size(E,1),NUM_SLOTS+8);

aux = find(abs(R)>corr_limit);
% l=1;
% E_entry(:,l) =  mean(E_classify(:, (aux >= 197) & (aux < 287) ),2); l=l+1;
% E_entry(:,l) =  mean(E_classify(:, (aux >= 318) & (aux < 487) ),2);l=l+1;
% E_entry(:,l) =  mean(E_classify(:,(aux >= 529) & (aux < 832) ),2);l=l+1;
% E_entry(:,l) =  mean(E_classify(:,(aux >= 995) & (aux <= 1170)),2);l=l+1;
% 
% E_aux = [];
% E_aux = E_classify(:,(aux >= 1164) & (aux <= 3343));
% signal_length = size(E_aux,2);
% slot_length = floor(signal_length/NUM_SLOTS);
% 
% E_entry(:,l) =  mean(E_classify(:,(aux >= 4427) & (aux <= 4567)),2);l=l+1;
% 
% E_entry(:,l) =  mean(E_classify(:,(aux >= 4850) & (aux <= 5258)),2);l=l+1;
% E_entry(:,l) =  mean(E_classify(:,(aux >= 5259) & (aux <= 5552)),2);l=l+1;
% 
% E_entry(:,l) =  mean(E_classify(:,(aux >= 7797) & (aux <= 8588)),2);


l=1;
E_entry(:,l) =  mean(E_classify(:, (aux >= 1) & (aux < 293) ),2); l=l+1;
E_entry(:,l) =  mean(E_classify(:, (aux >= 297) & (aux < 490) ),2);l=l+1;
E_entry(:,l) =  mean(E_classify(:,(aux >= 521) & (aux < 1001) ),2);l=l+1;
E_entry(:,l) =  mean(E_classify(:,(aux >= 1009) & (aux <= 1124)),2);l=l+1;

E_aux = [];
E_aux = E_classify(:,(aux >= 1143) & (aux <= 3935));
signal_length = size(E_aux,2);
slot_length = floor(signal_length/NUM_SLOTS);

E_entry(:,l) =  mean(E_classify(:,(aux >= 4446) & (aux <= 4576)),2);l=l+1;

E_entry(:,l) =  mean(E_classify(:,(aux >= 5889) & (aux <= 6265)),2);l=l+1;
E_entry(:,l) =  mean(E_classify(:,(aux >= 6629) & (aux <= 7326)),2);l=l+1;
 E_entry(:,l) =  mean(E_classify(:,(aux >= 7797) & (aux <= 8588)),2);

output_classes = classes(:,1);

for k=1:NUM_SLOTS
    E_entry(:,k+l) = mean(E_aux(:,(k-1)*slot_length+1:k*slot_length),2);
end

E_entry = [E_entry mean(P(:,1:57),2) mean(P(:,857:1004),2) mean(P(:,1332:1452),2)];

E_entry_ = E_entry;
output_classes_= output_classes;

for j=1:size(E_entry,2)  
    std(E_entry(:,j))
    E_entry(:,j) = (E_entry(:,j) - ones(size(E_entry(:,j)))*mean(E_entry(:,j)))/std(E_entry(:,j));
end

% for j=1:size(E_entry,2)   
%     E_entry_(:,j) = (E_entry_(:,j) - ones(size(E_entry_(:,j)))*mean(E_entry_(:,j)))/std(E_entry_(:,j));
% end

% k = 1:size(E,1);
% low_lim = 1100;
% upper_lim = 1300;
% E_entry = E_entry(k <= low_lim | k >= upper_lim,:);
% output_classes = output_classes(k <= low_lim | k>=upper_lim,:);

% E_entry = E_entry_;
% output_classes = (output_classes+1)/2;
