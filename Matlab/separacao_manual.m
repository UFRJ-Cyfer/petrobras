f_1 = sign(R_sp_pe) == -1;
f_2 = sign(R_pe_pi) == -1;
f_3 = sign(R_pi_sp) == -1;

f_ = 1*(f_1 | f_2 | f_3);



%% metodo 1
E_entry = zeros(size(E,1),8);

% E_entry(:,8)= E_T';

E_entry(:,1) = mean(E(:,(f>=1.71e4) & (f<=2.77e4) & f_),2);
E_entry(:,2) = mean(E(:,(f>=2.87e4) & (f<=3.67e4) & f_),2);
E_entry(:,3) = mean(E(:,(f>=3.67e4) & (f<=5.4e4) & f_),2);
E_entry(:,4) = mean(E(:,(f>=5.4e4) & (f<=6.1e4) & f_),2);
E_entry(:,5) = mean(E(:,(f>=6.6e4) & (f<=18e4) & f_),2);
E_entry(:,6) = mean(E(:,(f>=26.2e4) & (f<=31e4) & f_),2);
E_entry(:,7) = mean(E(:,(f>=32.4e4) & (f<=50e4) & f_),2);
E_entry(:,8) = max(Vallen);

% E_entry(:,8) = std(E(:,(f>=1.71e4) & (f<=2.77e4) & f_),0,2);
% E_entry(:,9) = std(E(:,(f>=2.87e4) & (f<=3.67e4) & f_),0,2);
% E_entry(:,10) = std(E(:,(f>=3.67e4) & (f<=5.4e4) & f_),0,2);
% E_entry(:,11) = std(E(:,(f>=5.4e4) & (f<=6.1e4) & f_),0,2);
% E_entry(:,12) = std(E(:,(f>=6.6e4) & (f<=18e4) & f_),0,2);
% E_entry(:,13) = std(E(:,(f>=26.2e4) & (f<=31e4) & f_),0,2);
% E_entry(:,14) = std(E(:,(f>=32.4e4) & (f<=50e4) & f_),0,2);
% E_entry(:,15) = max(Vallen);

%% metodo 2
NUM_SLOTS = 5;
 E_entry = zeros(size(E,1),NUM_SLOTS+8);
 E_classify = E(:,abs(R_pi)>corr_limit);

aux = find(abs(R_pi)>corr_limit);
l=1;
 freq_range_max_ = 3.05e5;		 
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
 
 
 for k=1:NUM_SLOTS
     E_entry(:,k+l) = mean(E_aux(:,(k-1)*slot_length+1:k*slot_length),2);
 end
 
 
 %% metodo 3
 
 
 E_entry(:,1) = mean(E(:,(f>=1.71e4) & (f<=2.77e4)),2);
E_entry(:,2) = mean(E(:,(f>=2.87e4) & (f<=3.67e4)),2);
E_entry(:,3) = mean(E(:,(f>=3.67e4) & (f<=5.4e4)),2);
E_entry(:,4) = mean(E(:,(f>=5.4e4) & (f<=6.1e4)),2);
E_entry(:,5) = mean(E(:,(f>=6.6e4) & (f<=18e4)),2);
E_entry(:,6) = mean(E(:,(f>=26.2e4) & (f<=31e4)),2);
E_entry(:,7) = mean(E(:,(f>=32.4e4) & (f<=50e4)),2);
E_entry(:,8) = max(Vallen);

 

%% normalizacao
for j=1:size(E_entry,2)  
    E_entry(:,j) = (E_entry(:,j) - ones(size(E_entry(:,j)))*mean(E_entry(:,j)))/std(E_entry(:,j));
end










t = 0:1000;
st = t/100 .* exp(-t/100);
fft_st = fft(st);
figure;
plot(angle(fft_st(1:500)))
plot(st)


delay = 100;
y = zeros(1,delay);
t_ = delay+1:1000;

y = [y ((t_-delay)/100.*exp(-(t_-delay)/100))];
fft_st_new = fft(y);
plot(angle(fft_st_new(1:1000)));


N   = 100;        % FIR filter order
Fp  = 2e3;       % 20 kHz passband-edge frequency
Fs  = 1e6;       % 96 kHz sampling frequency
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation

eqnum = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs

onda_filtrada = filter(eqnum,1,Vallen(:,1));
figure;
subplot(2,1,1)
plot(Vallen(:,1))
subplot(2,1,2)
plot(onda_filtrada)

d = designfilt('bandpassiir','FilterOrder',50, ...
    'HalfPowerFrequency1',0.15e5,'HalfPowerFrequency2',0.7e5, ...
    'SampleRate',1e6);
onda_filtrada_pb = filter(d, Vallen(:,1));
figure;
plot(onda_filtrada_pb)
