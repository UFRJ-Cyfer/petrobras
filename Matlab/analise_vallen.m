filename = 'idr02_02_ciclo1_1.txt';
pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 Vallen\';
load('Idr02_02_ciclo1_1.mat', 'Vallen')

replaceinfile(',', '.', [pathname,filename])
temp = importdata([filename], ' ', 4);

Holder = temp.data;
Holder = Holder(1:end-1,:);

t=temp.textdata(5:end-1);
[Y, M, D, H, MN, S] = datevec(t,'HH:MM:SS');

tempo_vallen = H*3600+MN*60+S;

Holder = [Holder tempo_vallen];
Holder(:,1) = Holder(:,1)/1000 + Holder(:,end);
Holder = Holder(:,1:end-1);
cleanHolder = Holder(~any(isnan(Holder),2),:);

timeVector = tempo_vallen + Holder(:,1)/1000;
timeVector = timeVector-timeVector(1);


timeVector = temp.data(:,2);
channels = temp.data(:,4);

channels = Holder(:,2);

waveIndexes = Holder(:,9);
waveIndexes(waveIndexes == 1) = 0;
waveIndexes(1) = 1;

timeWaves = [timeVector, Holder(:,9)];

figure;
plot(timeVector, Holder(:,9),'.')

timeVectorCaptured = timeVector(waveIndexes ~=0);

figure;
waveIndexesClean = waveIndexes(waveIndexes~=0);
plot(waveIndexesClean(1:end-1),diff(timeVectorCaptured),'.')
ylabel('Diferenca de Tempo (s)')
xlabel('Índice de forma de onda')
ylim([0 0.5])
grid on

figure;
edges = 0:0.0001:25;
histogram(diff(timeVectorCaptured),edges)
xlim([0 0.2])



for k=1:4
    timeDistribution(k).timeVector = timeVector(channels == k);
    timeDistribution(k).diffTimeVector = diff(timeVector(channels==k));
    
%     timeDistribution(k).timeVectorCaptured = timeVector(channels==k & waveIndexes ~= 0);
%     timeDistribution(k).timeVectorCapturedDiff = diff(timeVector(channels==k & waveIndexes ~= 0));
end
    edges = 0:0.01:25;

for k=1:4
    figure;
    histogram(timeDistribution(k).timeVectorCapturedDiff,edges)
    xlim([0 0.16])
    title(['Canal ' num2str(k)])
end


for k=1:8
    timeDistribution(k).waveIndexChannel = waveIndexes(channels==k);
    timeDistribution(k).waveIndexes = waveIndexes;
end

for k=1:4
    figure;
    histogram(timeDistribution(k).diffTimeVector,edges/10);
    title(['Delta T ' 'Canal ' num2str(k)])
    ylabel('Tempo (s)')
    xlabel('Tempo (s)')
    xlim([0 0.03])
    grid on;
    
    %
    %    figure;
    %    histogram(timeDistribution(k).diffTimeVector);
    %    title(['Delta T ' 'Canal ' num2str(k)])
    %    ylabel('Delta Tempo (s)')
    %    xlabel('Tempo (s)')
    %    grid on;
end

for k=1:8
    aux = timeDistribution(k).timeVector;
    %    aux = aux(1:end-1);
    
    figure;
    plot(aux,timeDistribution(k).timeVector,'.');
    title(['T ' 'Canal ' num2str(k)])
    ylabel('Tempo (s)')
    xlabel('Tempo (s)')
    grid on;
end