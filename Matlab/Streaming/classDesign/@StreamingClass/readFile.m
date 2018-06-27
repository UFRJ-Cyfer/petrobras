function rawData = readFile(this,cycle, fileNumber)
    try
        folderPath = this.folderTDMS{cycle};
    catch E
        folderPath = this.folderTDMS{1};
    end
    
    
filename = [this.fileTemplate{cycle} num2str(fileNumber,'%03d') '.tdms'];

        if strcmp(this.description,'CP4') && cycle == 1
            if this.sortedFolder(fileNumber) == 2
                rawData = readStreamingFile( filename, this.folderTDMS{3}, this.folderMatlabCopy);
            else
                rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy);
            end
        else
            rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy);
        end

end