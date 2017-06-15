% filename = 'idr02_02_ciclo1_1.txt';
% pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';

for time_window = [18000]
    
A = exist('Vallen','var');

if (~A)
load('Idr02_02_ciclo1_1.mat', 'Vallen')
%janelamento
figure;
x = [5000 9000 18000];
y=[min(min(Vallen(:,1))),max(max(Vallen(:,1)))];
plot(Vallen(:,1))
hold on;
plot([x(1) x(1)],y)
plot([x(2) x(2)],y)
plot([x(3) x(3)],y)
Vallen = Vallen(1:time_window,1:1492);

max_vallen = max(Vallen);
wave_indexes = 1:size(Vallen,2);

Vallen = Vallen(:, max_vallen>3.5e-4);
wave_indexes = wave_indexes(max_vallen>3.5e-4);

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
f = Fs*(0:(size(fft_vallen,1)/2))/size(fft_vallen,1);
f = f(1:end-1);

tempo = 1:size(Vallen,1);
tempo = tempo/Fs
coeffMA = ones(1, 100)/100;


time_sp = 897;
time_pi = 1300;

[~, I_sep] = find(wave_indexes >= time_sp);
time_sp = (I_sep(1));


[~, I_sep] = find(wave_indexes >= time_pi);
time_pi = (I_sep(1));

P = zeros(size(fft_vallen,1),size(fft_vallen,2));
% P = angle(fftshift(fft_vallen));
P = angle(fft_vallen);
P = P/pi;
P = P(1:size(P,1)/2,:);
% figure;
% plot(f,P)
% figure;
% plot(f,filter(coeffMA, 1, P))

figure; plot(f,mean(P(:,1:time_sp),2))
title(['Fase Média SP ' num2str(time_window) ' Points'])
ylabel('Ângulo (rad/pi)')
xlabel('Frequência (Hz)')
figure; plot(f,mean(P(:,time_sp+1:time_pi)/pi,2))
title(['Fase Média PE ' num2str(time_window) ' Points'])
ylabel('Ângulo (rad/pi)')
xlabel('Frequência (Hz)')
figure; plot(f,mean(P(:,time_pi:end),2))
title(['Fase Média PI ' num2str(time_window) ' Points'])
ylabel('Ângulo (rad/pi)')
xlabel('Frequência (Hz)')


P = filter(coeffMA, 1, P);

 E = zeros(size(fft_vallen,1),size(fft_vallen,2));
 E_not_norm = abs(fft_vallen).^2;
 
 E_T = sum(abs(fft_vallen).^2,1);
 E = abs(fft_vallen).^2./repmat(sum(abs(fft_vallen).^2),size(E,1),1);
 E = 2*E(1:size(E,1)/2,:);
 E = E';
 
figure; plot(f,mean(E(1:time_sp,:),1))
grid on
title(['E Normalizada Média SP ' num2str(time_window) ' Points'])
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')

figure; plot(f,mean(E(time_sp+1:time_pi,:)/pi,1))
grid on
title(['E Normalizada Média PE ' num2str(time_window) ' Points'])
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')

figure; plot(f,mean(E(time_pi:end,:),1))
grid on
title(['E Normalizada Média PI ' num2str(time_window) ' Points'])
ylabel('Energia Normalizada')
xlabel('Frequência (Hz)')
 

 E_not_norm = 2*E_not_norm(1:size(E_not_norm,1)/2,:);


%  E = zeros(size(clean_fft_vallen,1),size(clean_fft_vallen,2));
%  E = abs(clean_fft_vallen).^2;

checker = sum(E,1);
 
classes = ones(1,size(fft_vallen,2));

%SP -1
%PE 0
%PI 1
classes(:,1:time_sp) = -1;
classes(:,time_sp+1:time_pi) = 0;
classes(:,time_pi+1:end) = 1;

classes = repmat(classes,size(E,2),1);

classes  = classes';
P=P';

output_classes = classes(:,1);
y_classes = repmat(output_classes',3,1);
y_classes(:,1:time_sp) = repmat([1; 0; 0],1,time_sp);
y_classes(:,time_sp+1:time_pi) = repmat([0; 1; 0],1,time_pi-time_sp);
y_classes(:,time_pi+1:end) = repmat([0; 0; 1],1,size(y_classes(:,time_pi+1:end),2));

%R = mean((classes-repmat(mean(classes),size(classes,1),1)).*...
   % (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(classes,1),size(classes,1),1) ./ repmat(std(E,1),size(E,1),1));

sp_class = repmat(y_classes(1,:)',1,size(classes,2));
pe_class = repmat(y_classes(2,:)',1,size(classes,2));
pi_class = repmat(y_classes(3,:)',1,size(classes,2));

R_sp = mean((sp_class-repmat(mean(sp_class),size(sp_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(sp_class,1),size(sp_class,1),1) ./ repmat(std(E,1),size(E,1),1));

R_pe = mean((pe_class-repmat(mean(pe_class),size(pe_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(pe_class,1),size(pe_class,1),1) ./ repmat(std(E,1),size(E,1),1));

R_pi = mean((pi_class-repmat(mean(pi_class),size(pi_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(pi_class,1),size(pi_class,1),1) ./ repmat(std(E,1),size(E,1),1));

R_P = mean((classes-repmat(mean(classes),size(classes,1),1)).*...
    (P-repmat(mean(P),size(P,1),1)) ./ repmat(std(classes,1),size(classes,1),1) ./ repmat(std(P,1),size(P,1),1));

corr_limit = 2/sqrt(size(E,1));

%{
figure;
subplot(3,1,1)
plot(f,R_sp,'.');
hold on;
plot(f,ones(size(R_sp))*corr_limit,'r--')
plot(f,ones(size(R_sp))*corr_limit*-1,'r--')
 plot(f(find(abs(R_sp)>corr_limit)),R_sp(abs(R_sp)>corr_limit),'r.');
 title(['Correlações Cruzadas ' num2str(time_window) ' Points'])
% xlabel('Frequência (Hz)');
ylabel('Correlação SP');
grid on;

subplot(3,1,2)
plot(f,R_pe,'.');
hold on;
plot(f,ones(size(R_pe))*corr_limit,'r--')
plot(f,ones(size(R_pe))*corr_limit*-1,'r--')
 plot(f(find(abs(R_pe)>corr_limit)),R_pe(abs(R_pe)>corr_limit),'r.');
%  title('Energia Normalizada')
% xlabel('Frequência (Hz)');
ylabel('Correlação PE');
grid on;

subplot(3,1,3)
plot(f,R_pi,'.');
hold on;
plot(f,ones(size(R_pi))*corr_limit,'r--')
plot(f,ones(size(R_pi))*corr_limit*-1,'r--')
 plot(f(find(abs(R_pi)>corr_limit)),R_pi(abs(R_pi)>corr_limit),'r.');
%  title('Energia Normalizada')
% xlabel('Frequência (Hz)');
ylabel('Correlação PI');
grid on;

%}


%¨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1)
plot(f,R_sp,'.');
hold on;
title(['Correlações ' num2str(time_window) ' Pontos'])
plot(f,ones(size(R_sp))*corr_limit,'r--')
plot(f,ones(size(R_sp))*corr_limit*-1,'r--')
R_sp_pe = R_sp.*R_pe.*(abs(R_sp)>corr_limit).*(abs(R_pe)>corr_limit);

%  plot(f(find(sign(R_sp_pe(abs(R_sp)>corr_limit & abs(R_pe)>corr_limit)) == -1)),...
%      R_sp(sign(R_sp_pe(abs(R_sp)>corr_limit & abs(R_pe)>corr_limit)) == -1),'g.');
%  
 plot(f(find(sign(R_sp_pe) == -1)),...
    R_sp(sign(R_sp_pe) == -1),'g.');
 
 
%  title('Energia Normalizada')
% xlabel('Frequência (Hz)');
 ylabel('Correlação SP x PE');
% ylabel('Correlação SP');
grid on;

subplot(3,1,2)
plot(f,R_pe,'.');
hold on;
plot(f,ones(size(R_pe))*corr_limit,'r--')
plot(f,ones(size(R_pe))*corr_limit*-1,'r--')
R_pe_pi = R_pe.*R_pi.*(abs(R_pe)>corr_limit).*(abs(R_pi)>corr_limit);

 plot(f(sign(R_pe_pi) == -1),...
    R_pe(sign(R_pe_pi) == -1),'g.');
 
 %  title('Energia Normalizada')
% xlabel('Frequência (Hz)');
ylabel('Correlação PE x PI');
%ylabel('Correlação PE');
grid on;

subplot(3,1,3)
plot(f,R_pi,'.');
hold on;
plot(f,ones(size(R_pi))*corr_limit,'r--')
plot(f,ones(size(R_pi))*corr_limit*-1,'r--')
R_pi_sp = R_pi.*R_sp.*(abs(R_pi)>corr_limit).*(abs(R_sp)>corr_limit);

 plot(f(find(sign(R_pi_sp) == -1)),...
    R_pi(sign(R_pi_sp) == -1),'g.');

% xlabel('Frequência (Hz)');
ylabel('Correlação PI x SP');
%ylabel('Correlação PI');
xlabel('Frequência (Hz)')
grid on;

end



f_entry = f((sign(R_sp_pe) == -1) | (sign(R_pe_pi) == -1) | (sign(R_pi_sp) == -1));

min_distance = 3389; %experimental

n_groups = sum(diff(f_entry) >= 3389);
groups = repmat(struct('f_range',1), n_groups+1, 1 );

group_positions = find(diff(f_entry) >=3389);
group_positions = [1 group_positions size(f_entry,2)];

indexes_to_remove = [];
for n=1:n_groups+1
    groups(n).f_range = f_entry(group_positions(n):group_positions(n+1));
    groups(n).size = length(groups(n).f_range);
    if groups(n).size < 100
       indexes_to_remove = [indexes_to_remove n] ;
    end
end

groups(indexes_to_remove) = [];
clear indexes_to_remove

num_slots = [11 8];

groups_aux = repmat(struct('f_range',1), sum(num_slots), 1 );

index_group = 0;
for n=1:length(num_slots)
    samples_eliminate = mod(groups(n).size,num_slots(n));
    group_size = length(groups(n).f_range(1:end-samples_eliminate))/num_slots(n);
    f_range_groups = reshape(groups(n).f_range(1:end-samples_eliminate), num_slots(n), group_size);
    
    for k=1:size(f_range_groups,1)
       groups_aux(k+index_group).f_range = f_range_groups(k,:);
       groups_aux(k+index_group).size = length(groups_aux(k+index_group).f_range);
    end
    index_group = index_group+size(f_range_groups,1);
end

groups = groups_aux;
E_entry = zeros(size(E,1),length(groups)*2);
for k=1:length(groups)
    [~,Locb] = ismember(groups(k).f_range,f);
    E_entry(:,k) = mean(E(:,Locb),2);
    E_entry(:,k+length(groups)) = std(E(:,Locb),0,2);
end

% for k=1:10
%    E_entry(:,k) = mean(E(:,30*k),2) 
% end

E_entry = [E_entry E_T'];

output_classes = classes(:,1);
y_classes = repmat(output_classes',3,1);
y_classes(:,1:time_sp) = repmat([1; 0; 0],1,time_sp);
y_classes(:,time_sp+1:time_pi) = repmat([0; 1; 0],1,time_pi-time_sp);
y_classes(:,time_pi+1:end) = repmat([0; 0; 1],1,size(y_classes(:,time_pi+1:end),2));

E_entry_ = E_entry;


for j=1:size(E_entry,2)  
    E_entry(:,j) = (E_entry(:,j) - ones(size(E_entry(:,j)))*mean(E_entry(:,j)))/std(E_entry(:,j));
end

% E_entry = [E_entry; E_entry(time_sp:time_pi,:); E_entry(time_pi:end,:)];
% y_classes = [y_classes y_classes(:,time_sp:time_pi) y_classes(:,time_pi:end)];


% ah = findobj('Type','figure'); % get all figures
% for m=1:numel(ah) % go over all axes
%   set(findall(ah(m),'-property','FontSize'),'FontSize',16)
%    axes_handle = findobj(ah(m),'type','axes');
%    ylabel_handle = get(axes_handle,'ylabel');
%    saveas(ah(m),[ylabel_handle.String num2str(m) '.png'])
% end


%}

% ah = findobj('Type','figure'); % get all figures
% for m=1:numel(ah) % go over all axes
%   set(findall(ah(m),'-property','FontSize'),'FontSize',16)
%    axes_handle = findobj(ah(m),'type','axes');
%    ylabel_handle = get(axes_handle,'ylabel');
%    set(ah(m),'Color','w')
%   % saveas(ah(m),[ylabel_handle.String num2str(m) '.png'])
% end

