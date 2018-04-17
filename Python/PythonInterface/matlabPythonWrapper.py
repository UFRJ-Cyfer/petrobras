def streamingOBJWRapper(filename):
    import scipy.io as scio

    matContents = scio.loadmat(filename);
    waveStruct = matContents['waveStruct']
    mainStruct = matContents['outputStruct']

    return mainStruct,waveStruct

class Wave:
    rawData = -1
    channel = -1
    riseTime = -1
    count = -1
    energy = -1
    duration = -1
    rms = -1
    maxAmplitudeDB = -1
    resolutionLevelCount = -1
    averageSignalLevel = -1
    countToPeak = -1
    averageFrequency = -1
    reverberationFrequency = -1
    initiationFrequency  = -1
    maxAmplitude = -1
    threshold = -1

    absoluteTriggerIndex = -1
    triggerTime = -1
    relativeTriggerIndex = -1
    splitFile = False
    splitIndex = 0


KEYS = ['rawData','channel','riseTime', 'count','energy','duration','rms','maxAmplitudeDB','resolutionLevelCount',
        'averageSignalLevel','countToPeak','averageFrequency','reverberationFrequency','initiationFrequency','maxAmplitude',
        'threshold','absoluteTrigerIndex','triggerTime','relativeTriggerIndex','splitFile','splitIndex'];

mat_file = streamingOBJWRapper('J:\BACKUPJ\ProjetoPetrobras\Matlab\Data\streamingOBJ\structStreamingOBJ.mat')

mat_file = mat_file['outputStruct']
waves = mat_file['Waves']

waves[0]
