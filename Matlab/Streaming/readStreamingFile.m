function [ rawData ] = readStreamingFile( filename, path )
%READSTREAMINGFILE Summary of this function goes here
%   Detailed explanation goes here

N = 16777216;%t%parametro 2 do arquivo tdms

fa = 2.5e6;%Frequencia de aquisicao;
v = (10/(2^13*4));%fator de conversao de valor binario para volts

EXEpath = 'D:\Program Files (x86)\exportador pro hhaan';
EXEname = 'exportador_idr2';

filepath_tdms =  'D:\Program Files (x86)\exportador pro hhaan';
filename_tdms = 'ciclo2#001.tdms';

filepath_raw = 'D:\Program Files (x86)\exportador pro hhaan';
filename_raw = 'temp.raw';

% o conversor é acessivel pela linha de comando do shell do windows. e seus
% argumentos sao como segue:
% exportador_idr2 CAMINHOTDMS ng N CAMINHOBIN
commandline = sprintf('%s %s %d %d %s',EXEname,...
        [filepath_tdms '\' filename_tdms],...
        ng,N,...
        [filepath_raw '\' filename_raw])
    
dos(commandline);%faz a conversao com o .exe externo


%importa do arquivo binario para o matlab
data = ImportadorRAW([filepath_raw '\' filename_raw]);



end

