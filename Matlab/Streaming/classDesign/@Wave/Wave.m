classdef Wave
    % Class that contains an acoustic emission wave and its parameters
    %
    % :param rawData: Array that stores the entire wave, the values have no phisical meaning.
    % :type rawData: int16 array
    %
    % :param channel: Channel where the wave was captured from.
    % :type channel: uint8
    %
    % :param riseTime:  Time between triggerTime and the Maxmimum Amplitude in seconds.
    % :type riseTime: double
    %
    % :param count: Amount of times the wave has positively crossed over the Threshold.
    % :type count: double
    %
    % :param energy: Energy of wave,
    % :type energy: double
    %
    % :param duration: Duration of the wave, in seconds.
    % :type duration: double
    %
    % :param rms: RMS energy of the wave. 
    % :type rms: double
    %
    % :param maxAmplitudeDB: Maximum amplitude of the wave, in dB.
    % :type maxAmplitudeDB: double
    %
    % :param resolutionLevelCount: Amount of levels used to digitilize the wave.
    % :type resolutionLevelCount: uint16
    %
    % :param averageSignalLevel:  
    % :type averageSignalLevel: double
    %
    % :param countToPeak: Amount of times the wave has positively crossed the Threshold until the Max. Amplitude time.
    % :type countToPeak: double 
    %
    % :param averageFrequency:  Average Frequency of the wave.
    % :type averageFrequency: double 
    %
    % :param reverberationFrequency: Reverberation Frequency of the wave.
    % :type reverberationFrequency: double
    %
    % :param initiationFrequency: Initiation Frequency of the wave.
    % :type initiationFrequency: double
    %
    % :param maxAmplitude: Maximum amplitude of the wave.
    % :type maxAmplitude: int16
    %
    % :param threshold: The threshold used to capture the wave (3*noiseLevel of the file).
    % :type threshold: double
    % 
    % :param meanAmplitude:  Mean of the Amplitude of the wave.
    % :type meanAmplitude: double
    %
    % :param absoluteTriggerIndex:  The index (with respect to the file) where the trigger first ocurred.
    % :type absoluteTriggerIndex: double
    %
    % :param triggerTime: Absolute time of the entire test when the wave was capture, in seconds.
    % :type triggerTime: uint32
    %
    % :param relativeTriggerIndex: Always 5000 (irrelevant parameter)
    % :type relativeTriggerIndex: double
    %
    % :param splitFile: A Boolean that informs if the wave was capture between files.
    % :type splitFile: Bool
    %
    % :param splitIndex:  The index on the latter file (from the split) where the wave ended.
    % :type splitIndex:  double
    %
    % :param file: Which file the wave was captured from.
    % :type file: double
    
    properties
        rawData = -1
        channel = -1
        riseTime = -1
        count = -1
        energy = -1
        duration = -1
        rms = -1;
        maxAmplitudeDB = -1
        resolutionLevelCount = -1
        averageSignalLevel = -1
        countToPeak = -1
        averageFrequency = -1
        reverberationFrequency = -1
        initiationFrequency  = -1
        maxAmplitude = -1
        threshold = -1
        
        meanAmplitude = -1;
        absoluteTriggerIndex = -1
        triggerTime = -1
        relativeTriggerIndex= -1
        splitFile = false
        splitIndex = uint32(0);
        file = uint32(0);
    end
    methods
        function obj = Wave(varargin)
        % Wave class constructor, receives a variable-size input, however only instantiates 6 inputs.
        %
        %   :param varargin: All necessary parameters to instantiate a Wave Object. In order: rawData, channel, threshold, triggerTime, absoluteTriggerIndex, relativeTriggerIndex. 
        %   :type varargin: Cell Array
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





