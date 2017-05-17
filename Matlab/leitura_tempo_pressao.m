filename = 'IDR_COPPE - pressao x TOFD.xlsx';
pathname = 'H:\BitBucket\Projeto Petrobras\Ensaio IDR02 - 2 SEM Streaming\Amostra 2 pressão e TOFD\';

xls = xlsread([pathname filename]);

tempo_pressao = xls(2:end,1);
pressao = xls(2:end,2);

tempo_trinca = xls(1:end,4);
trinca = xls(1:end,5);

trinca(isnan(trinca)) = [];
tempo_trinca(isnan(tempo_trinca)) = [];

tempo_pressao = tempo_pressao(1:end-1);
tempo_trinca = tempo_trinca(1:end-1);
trinca = trinca(1:end-1);
pressao = pressao(1:end-1);

figure;
% hold on;
plotyy(tempo_pressao,pressao,tempo_trinca,trinca)
grid on;
hold on;
y_start = -200;
y_end = 400;
time_start = 2500;
times_PE = 5836;
times_PI = 7400;

plot([time_start time_start], [y_start y_end],'k--') 
plot([times_PE times_PE], [y_start y_end], 'k--') 
plot([times_PI times_PI], [y_start y_end], 'k--') 


% yyaxis left
% plot(tempo_pressao, pressao);

% yyaxis right
% plot(tempo_trinca, trinca);
% hold off;
vertical_cursors;
