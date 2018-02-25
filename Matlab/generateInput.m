function [neuralNetInput, chosenFrequencies, indexesChosenFrequencies] = ...
    generateInput(rawInput, frequencyDivisions, corrFigHandle,...
    greenFrequencies, greenValues, frequencyVector)

f = frequencyVector;

if isempty(frequencyDivisions)
    
    set(corrFigHandle, 'Visible', 'on');
    set(0, 'currentfigure', corrFigHandle);
    [freq, ~] = ginput;
    clickedAx = gca;
    
    for k=1:length(freq)-1
        if abs(freq(k) - freq(k+1)) < 1
            freq(k) = 0;
            break
        end
    end
else
    freq = frequencyDivisions;
%     set(corrFigHandle, 'Visible', 'on');
%     set(0, 'currentfigure', corrFigHandle);
%     clickedAx = gca;
end

numDivisions = length(freq)/2;


for i=1:length(freq)
    [~,I] = find((f-freq(i)) > 0,1);
    if I > 1
        freq(i) = f(I-1);
        indexes(i) = ind2sub(f,(I-1));
    else
        freq(i) = f(I);
        indexes(i) = subs(I);
    end
end

% for i=1:length(freq)
%     [~,I] = find((greenFrequencies-freq(i)) > 0,1);
%     if I > 1
%         freq(i) = greenFrequencies(I-1);
%         indexes(i) = ind2sub(greenFrequencies,(I-1));
%     else
%         freq(i) = greenFrequencies(I);
%         indexes(i) = subs(I);
%     end
% end


chosenFrequencies = freq;
indexesValidFrequency = ismember(f,greenFrequencies);
indexesChosenFrequencies = ismember(f,freq);

duplicates = [];
i=1;
for m=1:length(freq)-1
    if (freq(m)==freq(m+1))
        duplicates(i) = freq(m);
        i = i+1;
    end
end

duplicateLimits = find(ismember(f,duplicates));
frequencyLimits = find(indexesChosenFrequencies);

frequencyLimits = [frequencyLimits duplicateLimits];
frequencyLimits = sort(frequencyLimits);

for k=1:length(frequencyLimits)/2
    indexesChosenFrequencies(frequencyLimits(2*k-1):frequencyLimits(2*k)) = 1;
end

neuralNetInput = zeros(numDivisions*2, size(rawInput,2));
    for plotIndex = 1:3
subplot(3,1,plotIndex);

for k=1:numDivisions
    hold on;
%     plot(greenFrequencies(indexes(k*2-1):indexes(k*2)), greenValues(plotIndex,indexes(k*2-1):indexes(k*2)),'.')
    neuralNetInput(k,:) = mean(rawInput(frequencyLimits(2*k-1):frequencyLimits(2*k) ,:),1);
    neuralNetInput(numDivisions+k,:) = std(rawInput(frequencyLimits(2*k-1):frequencyLimits(2*k) ,:),0,1);
end
    end
hold off;



%
% f_entry = f((sign(R_sp_pe) == -1) | (sign(R_pe_pi) == -1) | (sign(R_pi_sp) == -1));
%
% min_distance = 3389; %experimental
%
% n_groups = sum(diff(f_entry) >= 3389);
% groups = repmat(struct('f_range',1), n_groups+1, 1 );
%
% group_positions = find(diff(f_entry) >=3389);
% group_positions = [1 group_positions size(f_entry,2)];
%
% indexes_to_remove = [];
% for n=1:n_groups+1
%     groups(n).f_range = f_entry(group_positions(n):group_positions(n+1));
%     groups(n).size = length(groups(n).f_range);
%     if groups(n).size < 100
%        indexes_to_remove = [indexes_to_remove n] ;
%     end
% end
%
% groups(indexes_to_remove) = [];
% clear indexes_to_remove
%
% num_slots = [11 8];
%
% groups_aux = repmat(struct('f_range',1), sum(num_slots), 1 );
%
% index_group = 0;
% for n=1:length(num_slots)
%     samples_eliminate = mod(groups(n).size,num_slots(n));
%     group_size = length(groups(n).f_range(1:end-samples_eliminate))/num_slots(n);
%     f_range_groups = reshape(groups(n).f_range(1:end-samples_eliminate), num_slots(n), group_size);
%
%     for k=1:size(f_range_groups,1)
%        groups_aux(k+index_group).f_range = f_range_groups(k,:);
%        groups_aux(k+index_group).size = length(groups_aux(k+index_group).f_range);
%     end
%     index_group = index_group+size(f_range_groups,1);
% end
%
% groups = groups_aux;
% E_entry = zeros(size(E,1),length(groups)*2);
% for k=1:length(groups)
%     [~,Locb] = ismember(groups(k).f_range,f);
%     E_entry(:,k) = mean(E(:,Locb),2);
%     E_entry(:,k+length(groups)) = std(E(:,Locb),0,2);
% end
%
% % for k=1:10
% %    E_entry(:,k) = mean(E(:,30*k),2)
% % end
%
% E_entry = [E_entry E_T'];
%
% output_classes = classes(:,1);
% y_classes = repmat(output_classes',3,1);
% y_classes(:,1:time_sp) = repmat([1; 0; 0],1,time_sp);
% y_classes(:,time_sp+1:time_pi) = repmat([0; 1; 0],1,time_pi-time_sp);
% y_classes(:,time_pi+1:end) = repmat([0; 0; 1],1,size(y_classes(:,time_pi+1:end),2));
%
% E_entry_ = E_entry;
%
%
% for j=1:size(E_entry,2)
%     E_entry(:,j) = (E_entry(:,j) - ones(size(E_entry(:,j)))*mean(E_entry(:,j)))/std(E_entry(:,j));
% end
%
%

%
%
%
% %% metodo 1
% E_entry = zeros(size(E,1),8);
%
% % E_entry(:,8)= E_T';
%
% E_entry(:,1) = mean(E(:,(f>=1.71e4) & (f<=2.77e4) & f_),2);
% E_entry(:,2) = mean(E(:,(f>=2.87e4) & (f<=3.67e4) & f_),2);
% E_entry(:,3) = mean(E(:,(f>=3.67e4) & (f<=5.4e4) & f_),2);
% E_entry(:,4) = mean(E(:,(f>=5.4e4) & (f<=6.1e4) & f_),2);
% E_entry(:,5) = mean(E(:,(f>=6.6e4) & (f<=18e4) & f_),2);
% E_entry(:,6) = mean(E(:,(f>=26.2e4) & (f<=31e4) & f_),2);
% E_entry(:,7) = mean(E(:,(f>=32.4e4) & (f<=50e4) & f_),2);
% E_entry(:,8) = max(Vallen);
%
% % E_entry(:,8) = std(E(:,(f>=1.71e4) & (f<=2.77e4) & f_),0,2);
% % E_entry(:,9) = std(E(:,(f>=2.87e4) & (f<=3.67e4) & f_),0,2);
% % E_entry(:,10) = std(E(:,(f>=3.67e4) & (f<=5.4e4) & f_),0,2);
% % E_entry(:,11) = std(E(:,(f>=5.4e4) & (f<=6.1e4) & f_),0,2);
% % E_entry(:,12) = std(E(:,(f>=6.6e4) & (f<=18e4) & f_),0,2);
% % E_entry(:,13) = std(E(:,(f>=26.2e4) & (f<=31e4) & f_),0,2);
% % E_entry(:,14) = std(E(:,(f>=32.4e4) & (f<=50e4) & f_),0,2);
% % E_entry(:,15) = max(Vallen);
%
% %% metodo 2
% NUM_SLOTS = 5;
%  E_entry = zeros(size(E,1),NUM_SLOTS+8);
%  E_classify = E(:,abs(R_pi)>corr_limit);
%
% aux = find(abs(R_pi)>corr_limit);
% l=1;
%  freq_range_max_ = 3.05e5;
%  E_entry(:,l) =  mean(E_classify(:, (aux >= 1) & (aux < 293) ),2); l=l+1;
%  E_entry(:,l) =  mean(E_classify(:, (aux >= 297) & (aux < 490) ),2);l=l+1;
%  E_entry(:,l) =  mean(E_classify(:,(aux >= 521) & (aux < 1001) ),2);l=l+1;
%  E_entry(:,l) =  mean(E_classify(:,(aux >= 1009) & (aux <= 1124)),2);l=l+1;
%
%  E_aux = [];
%  E_aux = E_classify(:,(aux >= 1143) & (aux <= 3935));
%  signal_length = size(E_aux,2);
%  slot_length = floor(signal_length/NUM_SLOTS);
%
%  E_entry(:,l) =  mean(E_classify(:,(aux >= 4446) & (aux <= 4576)),2);l=l+1;
%
%  E_entry(:,l) =  mean(E_classify(:,(aux >= 5889) & (aux <= 6265)),2);l=l+1;
%  E_entry(:,l) =  mean(E_classify(:,(aux >= 6629) & (aux <= 7326)),2);l=l+1;
%   E_entry(:,l) =  mean(E_classify(:,(aux >= 7797) & (aux <= 8588)),2);
%
%
%  for k=1:NUM_SLOTS
%      E_entry(:,k+l) = mean(E_aux(:,(k-1)*slot_length+1:k*slot_length),2);
%  end
%
%
%  %% metodo 3
%
%
%  E_entry(:,1) = mean(E(:,(f>=1.71e4) & (f<=2.77e4)),2);
% E_entry(:,2) = mean(E(:,(f>=2.87e4) & (f<=3.67e4)),2);
% E_entry(:,3) = mean(E(:,(f>=3.67e4) & (f<=5.4e4)),2);
% E_entry(:,4) = mean(E(:,(f>=5.4e4) & (f<=6.1e4)),2);
% E_entry(:,5) = mean(E(:,(f>=6.6e4) & (f<=18e4)),2);
% E_entry(:,6) = mean(E(:,(f>=26.2e4) & (f<=31e4)),2);
% E_entry(:,7) = mean(E(:,(f>=32.4e4) & (f<=50e4)),2);
% E_entry(:,8) = max(Vallen);
%
%
%
% %% normalizacao
% for j=1:size(E_entry,2)
%     E_entry(:,j) = (E_entry(:,j) - ones(size(E_entry(:,j)))*mean(E_entry(:,j)))/std(E_entry(:,j));
% end
%
%
%
%
%
%
%
%
%
%
% t = 0:1000;
% st = t/100 .* exp(-t/100);
% fft_st = fft(st);
% figure;
% plot(angle(fft_st(1:500)))
% plot(st)
%
%
% delay = 100;
% y = zeros(1,delay);
% t_ = delay+1:1000;
%
% y = [y ((t_-delay)/100.*exp(-(t_-delay)/100))];
% fft_st_new = fft(y);
% plot(angle(fft_st_new(1:1000)));



end