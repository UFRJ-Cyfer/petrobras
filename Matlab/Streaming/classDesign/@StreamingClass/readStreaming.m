function this = readStreaming(this)
CHANNELS = 1:16;
fs = 2.5e6;
for cycle=1:length(this.fileTemplate)
    lastIndexArray = zeros(1,16);
    boolMatrix = (this.numBitsFileChannel{cycle} >= this.minBits);
    
    
    filesToCheck = (sum(boolMatrix,2) > 0);
    auxVec = (1:length(filesToCheck));
    
    filesToCheck = filesToCheck.*auxVec';
    filesToCheck = filesToCheck(filesToCheck~=0);
    noiseLevelMatrix = zeros(length(filesToCheck),1+16);
    if cycle >=2
        this.cycleDividers(cycle-1) = this.countWaveform + 1;
    end
    
    try
        folderPath = this.folderTDMS{cycle};
        tofdDifferences = this.tofdDifferences{cycle};
    catch E
        folderPath = this.folderTDMS{1};
        tofdDifferences = this.tofdDifferences{1};
    end
    
    
    [~,ia,~] = intersect(filesToCheck, this.filesToSkip{cycle});
    filesToCheck(ia) = [];
    noiseLevelIndex = 1;
    for file=1:length(filesToCheck)
        
        
        tic
        fprintf(['Now verifying file %i\n'], filesToCheck(file))
        filename = [this.fileTemplate{cycle} num2str(filesToCheck(file),'%03d') '.tdms'];
        
        
        
        if strcmp(this.description,'CP4') && cycle == 1
            if this.sortedFolder(file) == 2
                rawData = readStreamingFile( filename, this.folderTDMS{3}, this.folderMatlabCopy);
            else
                rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy);
            end
        else
            rawData = readStreamingFile( filename, folderPath, this.folderMatlabCopy);
        end
        
        
        [ ~, noiseLevel, slots] =  removeTOFD( rawData, this.TOFDReferenceChannel);
        noiseLevelMatrix(noiseLevelIndex,1) = filesToCheck(file);
        noiseLevelMatrix(noiseLevelIndex,2:end) = noiseLevel;
        noiseLevelIndex = noiseLevelIndex+1;
        
        for j=CHANNELS
            if noiseLevel(j) < 500
                hasChannel = find(tofdDifferences.channels == j);
                if ~isempty(hasChannel)
                    newSlots = slots+tofdDifferences.deltaIndexes(hasChannel);
                    newSlots(newSlots<=0) = 1;
                    newSlots(newSlots>16777216) = 16777216;
                    rawData(newSlots,j) = NaN;
                end
            end
        end
        
        [this, lastIndexArray] = this.identifyWaves(rawData,...
            CHANNELS(boolMatrix(filesToCheck(file),:)), fs, ...
            noiseLevel, filesToCheck(file), lastIndexArray, this.folderMatlabCopy, cycle);
        
        
        elapsedTime = toc;
        fprintf('File analyzed in %.3f seconds \n', elapsedTime)
    end
    
    this.noiseLevelMatrix{cycle} = noiseLevelMatrix;
    
end
S.(this.description) = this;
save(['streamingOBJ' this.description],'-struct','S')
save(['streamingOBJ' this.description],'-struct','S','-v7.3')
end