
paths = {'O:\CP4-24.05.2016\Ciclo1-1de2','N:\CP4-24.05.2016\Ciclo1-2de2'};
listing = {dir(paths{1}),dir(paths{2})};

fileNames = [];
folder = zeros(1,size(listing{1,1},1) + size(listing{1,2},1));
filesIndexes = folder;
index = 1;
isOverThousand = 0;

for k=1:2
    for j=3:size(listing{1,k},1)
        activeFile = listing{1,k}(j).name;
        
        if isempty(strfind(activeFile,'log'))
            locationHashtag = strfind(activeFile,'#');
            fileNumber = str2num(activeFile(locationHashtag+1:locationHashtag+4));
            filesIndexes(index) = fileNumber;
            folder(index) = k;
            index = index+1;
        end
    end
end

