function this = trainModel(this, removeIndexes)

% 
% if exist(this.frequencyData,'var') ~= 1
%     this.createFrequencyData(2.5e6);
% else
%     if isempty(this.frequencyData)
%         this.createFrequencyData(2.5e6)
%     end
% end
% 
% 
% aux = 1:length(this.Waves);
% this.spIndexes = aux(triggerArray < this.timePE);
% this.peIndexes = aux(triggerArray >= this.timePE & triggerArray < this.timePI);
% this.piIndexes = aux(triggerArray >= this.timePI);
% 
% target = [repmat([1; 0; 0],1,length(this.spIndexes))...
%     repmat([0; 1; 0],1,length(this.peIndexes))...
%     repmat([0; 0; 1],1,length(this.piIndexes))];
% 
% input = this.defineInputs();

% if nargin >=2
%    input(:,args{1}) = []; 
%    target(:,args{1}) = [];
% end

dimensions = 1:15;

input = this.input.normalizedPower(dimensions,:);
target = this.target;

input(:,removeIndexes) = [];
target(:,removeIndexes) = [];
this.trainedModel = mainTrain(input, target, 'MLP', []);


end