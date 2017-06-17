function Draw = ImportadorRAW(fileraw)
m_raw = memmapfile(fileraw,'format','int16');
N = size(m_raw.Data,1);

term_leng = 2;%ou 2 ou 4
n_blcs = 4;
n_ch = 16;

ch_leng = (N-n_blcs*term_leng)/n_blcs/n_ch;

v_data = [ch_leng n_ch];
v_term = [term_leng 1];

m_raw = memmapfile(fileraw,'format',{...
    'int16', [2 1], 't1';...
    'int16', [ch_leng 16], 'd1';...
    'int16', [2 1], 't2';...
    'int16', [ch_leng 16], 'd2';...
    'int16', [2 1], 't3';...
    'int16', [ch_leng 16], 'd3';...
    'int16', [2 1], 't4';...
    'int16', [ch_leng 16], 'd4'...    
    });

d1 = swapbytes(m_raw.Data.d1);
d2 = swapbytes(m_raw.Data.d2);
d3 = swapbytes(m_raw.Data.d3);
d4 = swapbytes(m_raw.Data.d4);

Draw = cat(1,d1,d2,d3,d4);
end