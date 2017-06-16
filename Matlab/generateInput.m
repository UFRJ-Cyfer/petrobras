function neuralNetInput = generateInput()
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

end