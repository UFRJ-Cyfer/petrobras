classdef StreamingModel
    properties
        target = [];
        input = [];
        corrStruct = [];
        frequencyDivisions = [];
        figHandles = [];
        frequencyArray = [];
        trainedModel = [];
        variables = [];
    end
    
    methods
        function obj = StreamingModel(input, target)
            if nargin == 0
                
            else
                obj.input = input;
                obj.target = target;
            end
            
        end
        this = trainModel(this, removeIndexes);
        this = corrAnalysis(this, inputVariable, variableString);
        this = defineInputs(this)
        this = plotCorrAnalysis(this)
    end
    
    
end