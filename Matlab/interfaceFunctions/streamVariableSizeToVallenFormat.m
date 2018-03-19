function [mainVallen] = streamVariableSizeToVallenFormat(streamingObj, fftMatrix)

Fs = 2.5e6;
f = linspace(0, Fs/2, size(fftMatrix,1)); 

 triggerArray = streamingObj.propertyVector('triggerTime');
 
 absoluteFFT = abs(fftMatrix);
 
 %times for CP3
 timePE = 3000; %cp3
 timePI = 9000; %cp3
 
% separationIndexes.timeSP = find(triggerArray < timePE,1);
separationIndexes.timeSP  = find(triggerArray >= timePE & triggerArray < timePI,1);
separationIndexes.timePI  = find(triggerArray >= timePI,1);
 

E = zeros(size(absoluteFFT));
E_not_norm = absoluteFFT.^2;
E_T = sum(E_not_norm,1);
E = E_not_norm./repmat(E_T,size(E,1),1);

P = 0;

y_classes = zeros(3,size(absoluteFFT,2));
y_classes(:,1:separationIndexes.timeSP) = repmat([1; 0; 0],1,separationIndexes.timeSP);
y_classes(:,separationIndexes.timeSP+1:separationIndexes.timePI) = repmat([0; 1; 0],1,separationIndexes.timePI-separationIndexes.timeSP);
y_classes(:,separationIndexes.timePI+1:end) = repmat([0; 0; 1],1,size(y_classes(:,separationIndexes.timePI+1:end),2));



% Output Assigments

% mainVallen.timeDataRaw = VallenRaw;
% mainVallen.timeDataClean = mainVallen.timeDataRaw ;
% mainVallen.fftDataRaw = fft_vallen;
% mainVallen.waveIndexes = wave_indexes;
% mainVallen.phase = P;
mainVallen.energy = E_not_norm;
mainVallen.normalizedEnergy = E;
% mainVallen.timeVector = tempo;
mainVallen.frequencyVector = f;
mainVallen.totalEnergy = E_T;
mainVallen.separationIndexes = separationIndexes;
mainVallen.sparseCodification = y_classes;
% mainVallen.regularCodification = classes;
% mainVallen.waveIndexesNewAndOld = waveIndexesNewAndOld;
% mainVallen.wavesToKeep = wavesToKeep;
end