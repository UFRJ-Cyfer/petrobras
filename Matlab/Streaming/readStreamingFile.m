function [ rawData ] = readStreamingFile( filename, path )
%READSTREAMINGFILE Summary of this function goes here
%   Detailed explanation goes here
ng = 4;
N = 16777216;%t%parametro 2 do arquivo tdms

fa = 2.5e6;%Frequencia de aquisicao;
v = (10/(2^13*4));%fator de conversao de valor binario para volts

filepath_readFiles = 'J:\BACKUPJ\ProjetoPetrobras\CP3RAWCOPY';

EXEname = 'D:\exportador_idr2';

filepath_tdms = path;
filename_tdms = filename ;

filepath_raw = 'D:';
filename_raw = 'temp.raw';

% o conversor é acessivel pela linha de comando do shell do windows. e seus
% argumentos sao como segue:
% exportador_idr2 CAMINHOTDMS ng N CAMINHOBIN
commandline = sprintf('%s %s %d %d %s',EXEname,...
    [filepath_tdms '\' filename_tdms],...
    ng,N,...
    [filepath_raw '\' filename_raw]);

if exist([filepath_readFiles '\' filename_tdms(1:end-4) 'mat'], 'file') == 2
    holder = load([filepath_readFiles '\' filename_tdms(1:end-4) 'mat']);
    rawData = holder.rawData;
else
    dos(commandline);%faz a conversao com o .exe externo

    stats = dir([filepath_tdms '\' filename_tdms]);

    %importa do arquivo binario para o matlab
    if stats.bytes < 536800000
        rawData = [];
    else
        rawData = ImportadorRAW([filepath_raw '\' filename_raw]);
        for ch=1:16
            rawData(:,ch) = rawData(:,ch) - mean(rawData(:,ch));
        end
    end
    save([filepath_readFiles '\' filename_tdms(1:end-4) 'mat'],'rawData')
end
% rawData = v * rawData;
end

