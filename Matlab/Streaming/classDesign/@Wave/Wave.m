classdef Wave
    properties
        rawData = -1
        channel = -1
        riseTime = -1
        count = -1
        energy = -1 
        duration = -1 
        rms = -1;
        maxAmplitude = -1
        threshold = -1
        triggerTime = -1
        startingTime = -1
        absoluteTriggerIndex = -1
        absoluteStartingIndex = -1
        samplingFrequency = -1
    end
    methods
        function obj =  Wave(varargin)
            if nargin == 7
                obj.rawData = varargin{1};
                obj.channel = uint8(varargin{2});
                obj.threshold = varargin{3};
                obj.triggerTime = varargin{4};
                obj.startingTime = varargin{5};
                obj.absoluteTriggerIndex = varargin{6};
                obj.absoluteStartingIndex = varargin{7};
            end
        end

         this = calculateParameters(this)
    end
end
        

        
        