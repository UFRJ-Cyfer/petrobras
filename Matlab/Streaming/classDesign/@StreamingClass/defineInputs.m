function [this, inputMatrix] = defineInputs(this)
%Creates the input matrix to be used for training any model. It changes the input parameter inside the StreamingModel object.
%
%   :returns: A StreamingClass object with defined inputs stores at the StreamingModel object.
%   :returns: The matrix used to feed the model.
%
this.StreamingModel = this.StreamingModel.plotCorrAnalysis();
fieldNames = fieldnames(this.StreamingModel.corrStruct);

for k=1:length(this.Waves)
    this.Waves(k) = this.Waves(k).calculateParameters(2.5e6, this);
end


this.StreamingModel.variables = [3:16]; %14,12 
variables = this.StreamingModel.variables;
inputMatrix = zeros(length(variables),length(this.Waves));
% [3:7 9:11 13:16 18]
% [3:7 9:11 13 15 17 18]
%%%%%%%% [3:6 8 9 11 13 15 16] 

%0 1 2 3 4 5 6 7 8 9
%3 4 5 6 8 9 11 13 15 16
%4 8 13 15 16

indexMatrix = 1;
for k=variables
    inputMatrix(indexMatrix,:) = [this.Waves.(this.fields{k})];
    indexMatrix = indexMatrix+1;
end

this.StreamingModel = this.StreamingModel.generateInput(this);

for varIndex = 1:length(fieldNames)
    var = fieldNames{varIndex};   
    this.StreamingModel.input.(var) = [inputMatrix; this.StreamingModel.input.(var)];  
end

end