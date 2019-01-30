function [this, modelStruct] = divideClassesFrancesco(this)
tic
this = adjustCycles(this);

[triggerArray, I] = sort(this.propertyVector('triggerTime')); 

aux = 1:length(this.Waves);
aux = aux(I);
spIndexes = aux(triggerArray < this.timePE);
peIndexes = aux(triggerArray >= this.timePE & triggerArray < this.timePI);
piIndexes = aux(triggerArray >= this.timePI);
FIRSTINDEX = 10;

cost = zeros(1,(length(peIndexes)+length(spIndexes)-10));
if exist(['costPE' this.description '.mat'], 'file') == 2
    S = load(['costPE' this.description '.mat']);
    [~, FIRSTINDEX] = find(S.cost,1,'last');
    cost(1:length(S.cost)) = S.cost;
end

%PE DIVISION
lowestCost = inf;
target = zeros(2,length(spIndexes)+length(peIndexes));
indexCost = 1;
lowestIndex = 0;
for index=FIRSTINDEX:(length(peIndexes)+length(spIndexes)-10)
target(1,1:index) =  1;
target(2,index+1:end) = 1;

target(1,index+1:end) = 0;
target(2,1:index) = 0;

this.StreamingModel.target = target;
this.StreamingModel = this.StreamingModel.trainModel([spIndexes peIndexes],[10]);
err = sum(this.StreamingModel.trainedModel.confusionMatrix.validation,3);
err = (err(1,2) + err(2,1))/(err(1,1) + err(2,2));
cost(index) = err;

if err < lowestCost
   lowestCost = err;
   lowestIndex = index;
   lowestModel = this.StreamingModel;
end

if rem(index,5) == 0 || index == (length(peIndexes)+length(spIndexes)-10)
    save(['lowestCostPE' this.description '.mat'],'lowestCost')
    save(['lowestIndexPE' this.description '.mat'],'lowestIndex')
    save(['costPE' this.description '.mat'],'cost')
end
indexCost = indexCost+1;
end

modelStruct.lowestIndexPE = lowestIndex;
modelStruct.lowestCostPE = lowestCost;
modelStruct.costPE = cost;
modelStruct.bestModelPE = lowestModel;

save(['modelStructPE' this.description '.mat'],'modelStruct')


%PI DIVISION
FIRSTINDEX = 10;


cost = zeros(1,(length(peIndexes)+length(piIndexes)-10));
if exist(['costPE' this.description '.mat'], 'file') == 2
    S = load(['costPE' this.description '.mat']);
    [~, FIRSTINDEX] = find(S.cost,1,'last');
    cost(1:length(S.cost)) = S.cost;
end

lowestCost = inf;
target = zeros(2,length(piIndexes)+length(peIndexes));
indexCost = 1;
lowestIndex = 0;
for index=FIRSTINDEX:(length(peIndexes)+length(piIndexes)-10)
target(1,1:index) =  1;
target(2,index+1:end) = 1;

target(1,index+1:end) = 0;
target(2,1:index) = 0;


this.StreamingModel.target = target;
this.StreamingModel = this.StreamingModel.trainModel([peIndexes piIndexes],[10]);
err = sum(this.StreamingModel.trainedModel.confusionMatrix.validation,3);
err = (err(1,2) + err(2,1))/(err(1,1) + err(2,2));
cost(index) = err;

if err < lowestCost
   lowestCost = err;
   lowestIndex = index;
   lowestModel = this.StreamingModel;
end
indexCost = indexCost+1;


if rem(index,5) == 0 || index == (length(peIndexes)+length(piIndexes)-10)
    save(['lowestCostPI' this.description '.mat'],'lowestCost')
    save(['lowestIndexPI' this.description '.mat'],'lowestIndex')
    save(['costPI' this.description '.mat'],'cost')
end
end

modelStruct.lowestIndexPI = lowestIndex;
modelStruct.lowestCostPI = lowestCost;
modelStruct.costPI = cost;
modelStruct.bestModelPI = lowestModel;
save(['modelStructPI' this.description '.mat'],'modelStruct')

toc
end