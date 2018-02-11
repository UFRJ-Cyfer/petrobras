function [ propertyArray ] = propertyVector( this, propertyString )
%PROPERTYVECTOR Summary of this function goes here
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
    case 'maxAmplitude'
        propertyArray = [this.Waves.maxAmplitude];
    case 'threshold'
        propertyArray = [this.Waves.threshold];
    case 'triggerTime'
        propertyArray = [this.Waves.triggerTime];
    case 'startingTime'
        propertyArray = [this.Waves.startingTime];
    otherwise
        fprintf('No such %s property!' , propertyString)
end

end

