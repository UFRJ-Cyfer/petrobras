function [this] = verifyStreamingResolution(this, cycle, initialFile)

interpolateTwoVector = [1 2 4 8 16 32 64 128 256 516 1024 2048 4096 8192 16384];

numBitsFileChannel = zeros(this.totalFiles(cycle),16);
numUniqueElementsChannel = numBitsFileChannel;

try
    folderPath = this.folderTDMS{cycle};
catch E
    folderPath = this.folderTDMS{1};
end

for fileNumber = initialFile:this.totalFiles(cycle)
    
    
    filename = [this.fileTemplate{cycle} num2str(fileNumber,'%03d') '.tdms'];
    %converter
    
    if strcmp(this.description,'CP4') && cycle == 1
        if this.sortedFolder(fileNumber) == 2
            rawData = readStreamingFile( filename, this.folderTDMS{3}, this.folderMatlabCopy,0);
        else
            rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy, 0); 
        end
    else
        rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy, 0);
        
    end
    
    if ~isempty(rawData)
        tic
        for channel=1:16
            numUniqueElements = length(unique(rawData(:,channel)));
            
            numberOfBits =(find(numUniqueElements <= interpolateTwoVector,1) - 1);
            
            
            numBitsFileChannel(fileNumber,channel) = numberOfBits;
            numUniqueElementsChannel(fileNumber,channel) = numUniqueElements;
        end
        toc
    end
    %     if ~isempty(find(numberOfBits >= numBitsFileChannel(fileNumber,:),1))
    %         save([backupPath{k} '\' filename(1:end-4) 'mat'],'rawData')
    %     end
end

save(['bitsPerChannel' this.description '_Ciclo_' num2str(cycle)],'numBitsFileChannel','numUniqueElementsChannel')
this.numBitsFileChannel{cycle} = numBitsFileChannel;
this.numUniqueElementsChannel{cycle} = numUniqueElementsChannel;
end