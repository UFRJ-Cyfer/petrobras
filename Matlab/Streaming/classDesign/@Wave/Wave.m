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
        resolutionLevelCount = -1
        threshold = -1
        triggerTime = -1
        absoluteTriggerIndex = -1
        relativeTriggerIndex= -1
        splitFile = false
        splitIndex = uint32(0);
    end
    methods
        function obj =  Wave(varargin)
            if nargin == 6
                obj.rawData = varargin{1};
                obj.channel = uint8(varargin{2});
                obj.threshold = varargin{3};
                obj.triggerTime = varargin{4};
                obj.absoluteTriggerIndex = uint32(varargin{5});
                obj.relativeTriggerIndex = uint32(varargin{6});
            end
        end

         this = calculateParameters(this, fs, streamingClass)
    end
end
        

        
        