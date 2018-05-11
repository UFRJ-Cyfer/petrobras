
function [ propertyArray ] = propertyVector( this, propertyString )
%PROPERTYVECTOR Returns arrays for each property of Wave object

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
    case 'maxAmplitudeDB'
        propertyArray = [this.Waves.maxAmplitudeDB];
    case 'averageSignalLevel'
        propertyArray = [this.Waves.averageSignalLevel];
    case 'resolutionLevelCount'
        propertyArray = [this.Waves.resolutionLevelCount];
    case 'meanAmplitude'
        propertyArray = [this.Waves.meanAmplitude];
    case 'countToPeak'
        propertyArray = [this.Waves.countToPeak];
    case 'averageFrequency'
        propertyArray = [this.Waves.averageFrequency];
    case 'reverberationFrequency'
        propertyArray = [this.Waves.reverberationFrequency];
    case 'initiationFrequency'
        propertyArray = [this.Waves.initiationFrequency];
    case 'resolution'
        propertyArray = [this.Waves.resolutionLevelCount];
    case 'threshold'
        propertyArray = [this.Waves.threshold];
    case 'triggerTime'
        propertyArray = [this.Waves.triggerTime];
    case 'splitFile'
        propertyArray = [this.Waves.splitFile];
    case 'splitIndex'
        propertyArray = [this.Waves.splitIndex];
    case 'absoluteTriggerIndex'
        propertyArray = [this.Waves.absoluteTriggerIndex];
    case 'relativeTriggerIndex'
        propertyArray = [this.Waves.relativeTriggerIndex];
    case 'rawData'
        propertyArray = {this.Waves.rawData};
    otherwise
        fprintf('No such %s property!' , propertyString)
end

end

