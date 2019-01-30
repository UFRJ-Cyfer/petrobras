%The main script for the Petro Acoustic Emission work
%
% some descriptions...
%
CP2 = CP2.adjustCycles(); %Adjusting CP2
CP4 = CP4.adjustCycles(); %Adjusting CP3
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
% 
% CP2.StreamingModel = CP2.StreamingModel.corrAnalysisChannel(CP2.normalizedPower, 'normalizedPower',7,CP2.propertyVector('channel'));
% CP3.StreamingModel = CP3.StreamingModel.corrAnalysisChannel(CP3.normalizedPower, 'normalizedPower',7,CP3.propertyVector('channel'));
% CP4.StreamingModel = CP4.StreamingModel.corrAnalysisChannel(CP4.normalizedPower, 'normalizedPower',7,CP4.propertyVector('channel'));

CP2.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;
CP3.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;
CP4.StreamingModel.frequencyDivisions.normalizedPower = frequencyDivisions;

[CP2, inputMatrixCP2] = CP2.defineInputs();
[CP3, inputMatrixCP3] = CP3.defineInputs();
[CP4, inputMatrixCP4] = CP4.defineInputs();

CP3.StreamingModel.frequencyDivisions.normalizedPower = []
[CP2.StreamingModel ,rel2]= CP2.StreamingModel.relevanceAnalysis();
[CP3.StreamingModel ,rel3]= CP3.StreamingModel.relevanceAnalysis();
[CP4.StreamingModel ,rel4]= CP4.StreamingModel.relevanceAnalysis();

% [CP4, modelStructCP4] = CP4.divideClassesFrancesco();
% [CP2, modelStructCP2] = CP2.divideClassesFrancesco();
% [CP3, modelStructCP3] = CP3.divideClassesFrancesco();

CP2.StreamingModel = CP2.StreamingModel.trainModel([],[10]);
CP4.StreamingModel = CP4.StreamingModel.trainModel([],[10]);
CP3.StreamingModel = CP3.StreamingModel.trainModel([],[10]);


100*mean(CP2.StreamingModel.trainedModel.confusionMatrix.percentValidation,3)
100*mean(CP3.StreamingModel.trainedModel.confusionMatrix.percentValidation,3)


100*std(CP2.StreamingModel.trainedModel.confusionMatrix.percentValidation,[], 3)
100*std(CP3.StreamingModel.trainedModel.confusionMatrix.percentValidation,[], 3)
100*std(CP4.StreamingModel.trainedModel.confusionMatrix.percentValidation,[], 3)

CP4.reportStreaming();
CP2.reportStreaming();
CP3.reportStreaming();




%dynamic range
for k=1:size(CP3.StreamingModel.input.normalizedPower)

    dRange_(k) = max(CP3.StreamingModel.input.normalizedPower(k,:)) - ...
        min(CP3.StreamingModel.input.normalizedPower(k,:));
    
end

indexesBTZ = CP3.StreamingModel.input.normalizedPower > 0;
CP3.StreamingModel.input.normalizedPower(indexesBTZ) =...
    log10(CP3.StreamingModel.input.normalizedPower(indexesBTZ));






% totalOutput =[];
% 
% for k=1:100
% totalOutput(:,:,k)= CP2.StreamingModel.trainedModel.outputRuns(k).filteredOutput;
% end
% 
% figure;
% totalOutput = mean(totalOutput,3);
% rgb = reshape(totalOutput', 1, size(totalOutput,2), 3);
% imagesc(rgb)
% 
% CP2.StreamingModel.trainModel()
% 
% aux = 1:1:(length(CP3.Waves));
% indexes1422 = aux(CP3.propertyVector('file') == 1422);
% 
% figure
% for k=1:length(indexes1422)
%   plot(CP3.Waves(k).rawData)
%   title(CP3.Waves(k).absoluteTriggerIndex)
%   pause;
% end
farChannelsCP3 = [1 2 7 8 13];
closeChannelsCP3 = [3 4 5 6 9 10 11 12 14 15 16];

farChannelsCP2 = [1 2 3 8 9 10 11 16];
closeChannelsCP2 = [4 5 6 7 12 13 14 15];

preferenceChannelsCP3 =[7 8 1 2 13 3 4 5 6 9 10 11 12 14 15 16];
preferenceChannelsCP4 = preferenceChannelsCP3;
preferenceChannelsCP2 =[15 14 13 12 6 7 5 4 11 8 3 9 2 16 10 1];

ch = CP2.propertyVector('channel');
indexesClose = zeros(1,length(CP2.Waves));
for k=closeChannelsCP2
    
indexesClose = indexesClose + (ch==k);
end
auxx = 1:length(CP2.Waves);
indexesFar = zeros(1,length(CP2.Waves));
for k=farChannelsCP2
    
indexesFar = indexesFar + (ch==k);
end


waveI = 1;
indexesFound = [];
waves = [];
lastWave = 0;
ind = CP4.identifySameWaves();
ch = CP4.propertyVector('channel');
for k=1:length(ind)
    
    if isempty(find(indexesFound == ind(k),1))
    for l=preferenceChannelsCP4
       if ch(k) == l
        waves = [waves k];
        indexesFound = [indexesFound ind(k)];
        break;
       end
    end
    end
end





tt = CP3.StreamingModel.target(:,waves);


[y, cmatrix]= CP3.StreamingModel.testWaves((logical(indexesFar)));

[y, cmatrix]= CP3.StreamingModel.testWaves(C);



ind = CP3.identifySameWaves();
mean(cmatrix,3)
target = CP3.StreamingModel.target(:,logical(indexesFar));
aux = repmat([1:size(target,1)]',1, size(target,2));
target = sum(target.*aux,1);

target = repmat(target,size(y,1),1);
chFar = repmat(ch(logical(indexesFar)), size(y,1),1);
err = (target-y) ~= 0;


figure
subplot(3,1,1)
histogram(ch)


subplot(3,1,2)
histogram(chFar)

subplot(3,1,3)
histogram(chFar(err))

figure;
histogram(chFar(~err))



size = 1e3;
x = linspace(-10,10,size);
sp = (tanh(-x-4)+1)/2;
pi = (tanh(x-4)+1)/2;
pe = (1 - sp) - pi;
figure
hold off;plot(sp);hold on;plot(pe); plot(pi);
legend('sp','pe','pi')

tt = CP3.propertyVector('triggerTime');
tt = tt-mean(tt);
tt = -tt/min(tt);
size = length(CP3.Waves);
x = linspace(tt(1),tt(end),size);

x=tt;
sp = (tanh(-x*(3/1e3) + 6)+1)/2;
pi = (tanh(x*(3/1e3) - 14)+1)/2;
pe = (1 - sp) - pi;
figure
hold off;plot(sp);hold on;plot(pe); plot(pi);
legend('sp','pe','pi')

target = [sp;pe;pi];








results{10,11,11} = [];
i = 1;
for k=0:10
    for l=0:10
        for m=1:10

%              results{m, k+1, l+1} = CP3.StreamingModel.trainModel(C, netStruct);
           smodel =  results{m, k+1, l+1};
           confusion =100*mean(smodel.trainedModel.confusionMatrix.percentValidation,3);
            spPercentageArray(i) = confusion(1,1);
            pePercentageArray(i) = confusion(2,2);
            piPercentageArray(i) = confusion(3,3);
            spErrPercentageArray(i) = confusion(1,2);
            if i==68
                k
                l
                m
            end
            i = i+1;
        end
    end
end


results{10,11,11} = [];
for k=0:10
    for l=0:10
        for m=1:10
            if k==0
                netStruct = [m l];
            end
            if l==0
                netStruct = [m];
            end

            if l ~= 0 && k~= 0
               netStruct = [m l k];
            end
             results{m, k+1, l+1} = CP3.StreamingModel.trainModel(C, netStruct);
        end
    end
end

fieldNames = fieldnames(CP2.Waves(1));
fieldNames = fieldNames(CP3.StreamingModel.variables);
saveStructCP2.power = CP2.power;
saveStructCP2.normalizedPower = CP2.normalizedPower;
saveStructCP2.inputMatrix = inputMatrixCP2;
saveStructCP2.frequencyMatrix = CP2.StreamingModel.input.normalizedPower(15:end,:);
saveStructCP2.fieldNames = fieldNames;

saveStructCP3.power = CP3.power;
saveStructCP3.normalizedPower = CP3.normalizedPower;
saveStructCP3.frequencyMatrix = CP3.StreamingModel.input.normalizedPower(15:end,:);
saveStructCP3.inputMatrix = inputMatrixCP3;
saveStructCP3.fieldNames = fieldNames;

saveStructCP4.power = CP4.power;
saveStructCP4.normalizedPower = CP4.normalizedPower;
saveStructCP4.inputMatrix = inputMatrixCP4;
saveStructCP4.frequencyMatrix = CP4.StreamingModel.input.normalizedPower(15:end,:);
saveStructCP4.fieldNames = fieldNames;

target = CP2.StreamingModel.target;
save('targetCP2.mat','target')

target = CP3.StreamingModel.target;
save('targetCP3.mat','target')

target = CP4.StreamingModel.target;
save('targetCP4.mat','target')


save('dadosCP2.mat','-struct' ,'saveStructCP2')
save('dadosCP3.mat','-struct' ,'saveStructCP3')
save('dadosCP4.mat','-struct' ,'saveStructCP4')

complementaryStructCP2.channel = CP2.propertyVector('channel');
complementaryStructCP2.triggerTime = CP2.propertyVector('triggerTime');

complementaryStructCP3.channel = CP3.propertyVector('channel');
complementaryStructCP3.triggerTime = CP3.propertyVector('triggerTime');

complementaryStructCP4.channel = CP4.propertyVector('channel');
complementaryStructCP4.triggerTime = CP4.propertyVector('triggerTime');

save('complementaryDataCP2.mat','-struct' ,'complementaryStructCP2')
save('complementaryDataCP3.mat','-struct' ,'complementaryStructCP3')
save('complementaryDataCP4.mat','-struct' ,'complementaryStructCP4')
Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 10000;             % Length of signal
t = (0:L-1)*T;        % Time vector
N = 2^24;

S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

Y = fft(S,N);
P2 = abs(Y/L);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(N/2))/N;

plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

