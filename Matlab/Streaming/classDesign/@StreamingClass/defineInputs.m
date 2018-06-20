function [this] = defineInputs(this)


this.StreamingModel = this.StreamingModel.plotCorrAnalysis();
fieldNames = fieldnames(this.StreamingModel.corrStruct);

for k=1:length(this.Waves)
    this.Waves(k) = this.Waves(k).calculateParameters(2.5e6, this);
end


this.StreamingModel.variables = [3:6 8 9 11 13 15 16]; %14,12 
variables = this.StreamingModel.variables;
inputMatrix = zeros(length(variables),length(this.Waves));
% [3:7 9:11 13:16 18]
% [3:7 9:11 13 15 17 18]
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