
CP2 = CP2.adjustCycles();
CP4 = CP4.adjustCycles();
CP3 = CP3.adjustCycles();

CP4CH1 = CP4.propertyVector('channel') == 1;
filesCP4 = CP4.propertyVector('file');
filesCP4 = filesCP4(1:500); %guarantee first cycle;
CP4CH1 = CP4CH1(1:500);

removeCP2 = 1:171;
removeCP3 = 1:193;
removeCP4 = [1:125 find(CP4CH1 & (filesCP4 >= 360) & (filesCP4<=402))];

CP2.Waves(removeCP2) = [];
CP3.Waves(removeCP3) = [];
CP4.Waves(removeCP4) = [];

CP2 = CP2.divideClasses();
CP4 = CP4.divideClasses();
CP3 = CP3.divideClasses();

CP2 = CP2.createFrequencyData(2.5e6);
CP4 = CP4.createFrequencyData(2.5e6);
CP3 = CP3.createFrequencyData(2.5e6);

CP2.StreamingModel = CP2.StreamingModel.corrAnalysis(CP2.normalizedPower, 'normalizedPower');
CP4.StreamingModel = CP4.StreamingModel.corrAnalysis(CP4.normalizedPower, 'normalizedPower');
CP3.StreamingModel = CP3.StreamingModel.corrAnalysis(CP3.normalizedPower, 'normalizedPower');

load('J:\BACKUPJ\ProjetoPetrobras\frequencyDivisions_NEW.mat')

CP2.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;
CP3.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;
CP4.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;

[CP2, inputMatrixCP2] = CP2.defineInputs();
[CP3, inputMatrixCP3] = CP3.defineInputs();
[CP4, inputMatrixCP4] = CP4.defineInputs();