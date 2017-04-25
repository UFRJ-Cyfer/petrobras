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

% yyaxis left
% plot(tempo_pressao, pressao);

% yyaxis right
% plot(tempo_trinca, trinca);
% hold off;
vertical_cursors;
