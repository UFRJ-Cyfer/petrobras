classdef StreamingModel
%StreamingModel class, used to hold any important variables to train a neural network model. With the frequency data from the correlation analysis.
%
%
% :param target: Target variable for training.
% :type target: double Array
%
% :param input: Input variable for training.
% :type input: double Array
%
% :param corrStruct: Structure containing the results from the correlation analysis.
% :type corrStruct: struct
%
% :param frequencyDivisions: Relevant frequencies (from the correlation analysis). 
% :type frequencyDivisions: double Array
%
% :param indexesChosenFrequencies: Logical array for the chosen frequencies. 
% :type indexesChosenFrequencies: bool Array
%
% :param figHandles: Figure handles from the correlation analysis.
% :type figHandles: Handle
%
% :param frequencyArray: Array of frequencies.
% :type frequencyArray: double Array
%
% :param trainedModel: Contains all information regarding the trained model (like confusion matrices).
% :type trainedModel: struct
%
% :param variables: Strings that specify which acoustic emission parameters were used.
% :type variables: Cell Array
%

    properties
        target = [];
        input = [];
        corrStruct = [];
        frequencyDivisions = struct('power',[],'normalizedPower',[],'phase',[]);
        indexesChosenFrequencies = struct('power',[],'normalizedPower',[],'phase',[]);
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
        this = trainModel(this, removeIndexes,neuralNetStructure)
        this = corrAnalysis(this, inputVariable, variableString)
        this = corrAnalysisChannel(this, inputVariable, variableString,channel,chArray)
        this = defineInputs(this)
        this = plotCorrAnalysis(this)
        this = generateInput(this, streamingClass)
        [this,rel] = relevanceAnalysis(this,streamingModel)
        [y,cmatrix] = testWaves(this,indexes)
    end
    
    
end