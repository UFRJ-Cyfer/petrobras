function [ propertyArray ] = propertyVector( this, propertyString )
%PROPERTYVECTOR Returns arrays for each property of Wave object
%   Detailed explanation goes here

switch propertyString
    case 'channel'
        propertyArray = [this.Waves.channel];
    case 'riseTime'
        propertyArray = [this.Waves.riseTime];
    case 'count'
        propertyArray = [this.Waves.count];
    case 'energy'
        propertyArray = [this.Waves.energy];
    case 'duration'
        propertyArray = [this.Waves.duration];
    case 'rms'
        propertyArray = [this.Waves.rms];
    case 'maxAmplitude'
        propertyArray = [this.Waves.maxAmplitude];
    case 'resolution'
        propertyArray = [this.Waves.resolutionLevelCount];
    case 'threshold'
        propertyArray = [this.Waves.threshold];
    case 'triggerTime'
        propertyArray = [this.Waves.triggerTime];
    case 'absoluteTrigger'
        propertyArray = [this.Waves.absoluteTriggerIndex];
    case 'rawData'
        propertyArray = {this.Waves.rawData};
    otherwise
        fprintf('No such %s property!' , propertyString)
end

end

