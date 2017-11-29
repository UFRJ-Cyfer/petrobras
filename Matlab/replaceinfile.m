function replaceinfile(str1, str2, FileName)
%REPLACEINFILE replaces commas with dots.

%% check inputs
if ~(ischar(str1) && ischar(str2))
    error('Invalid string arguments.')
end
%%replace
Data = fileread(FileName);
Data = strrep(Data, str1, str2);
FID = fopen(FileName, 'w');
fwrite(FID, Data, 'char');
fclose(FID);