function this = generateInput(this, streamingClass)

%GENERATEINPUT Creates the neural net input matrix 

% Input Explanation
% rawInput - The main array used to create the input. All calculations are
% done on it, and it's completely generic.
%
% frequencyDivisions - The slots used for the said calculations, for now
% they hold the limits on which this function calculates a mean and std.
%
% corrFigHandle - A handle for the figures previously done with the
% correlation analysis function, it is used to visually define the slots
% previously stated. It creates the frequencyDivisions/chosenFrequencies if
% it is empty as the function is called (frequencyDivisions = [])
%
% greenFrequencies - Special frequencies that have a correlation 
% coefficient with different signals when comparing with corrCoef's two
% different classes, a more detailed explanation can be found on the
% correlationAnalysis.m documentation
%
% greenValues - The correlation coefficient of said Green Frequencies
% Note that the last both inputs can be used on a more generalized way.
%
% frequencyVector - Just a vector used to translate indexes to real
% frequencies, mostly used to clarify the plots.
%

% USAGE
% 
% This function uses greenFrequencies to calculate the relevant indexes on
% the main data array, rawData, that are going to be used to generate the
% main input matrix for the neural net. Please note that this is completely
% generic, if a study on relevant (said so by the correlation analysis)
% frequencies and their absolute value from the FFT is needed, then rawData
% is going to be said absolute value, and this function will return/use
% these relevant slots.

% If however, the need is to now to create a input matrix using the phase
% information from the FFT, simply use rawData as an array containing said
% phase values. 
%
%
if isempty(this.figHandles)
   this.plotCorrAnalysis(); 
end

fieldNames = fieldnames(this.corrStruct);

for varIndex = 1:length(fieldNames)
    var = fieldNames{varIndex};
    corrFigHandle = this.figHandles(varIndex);
    rawInput = streamingClass.(var);

f = this.frequencyArray;

if isempty(this.frequencyDivisions.(var))
    
    set(corrFigHandle, 'Visible', 'on');
    set(0, 'currentfigure', corrFigHandle);
    [freq, ~] = ginput;
    clickedAx = gca;
    
    for k=1:length(freq)-1
        if abs(freq(k) - freq(k+1)) < 1
            freq(k) = 0;
            break
        end
    end
else
    freq = this.frequencyDivisions.(var);
%     set(corrFigHandle, 'Visible', 'on');
%     set(0, 'currentfigure', corrFigHandle);
%     clickedAx = gca;
end

numDivisions = length(freq)/2;


for i=1:length(freq)
    [~,I] = find((f-freq(i)) > 0,1);
    if I > 1
        freq(i) = f(I-1);
        indexes(i) = ind2sub(f,(I-1));
    else
        freq(i) = f(I);
        indexes(i) = subs(I);
    end
end

% for i=1:length(freq)
%     [~,I] = find((greenFrequencies-freq(i)) > 0,1);
%     if I > 1
%         freq(i) = greenFrequencies(I-1);
%         indexes(i) = ind2sub(greenFrequencies,(I-1));
%     else
%         freq(i) = greenFrequencies(I);
%         indexes(i) = subs(I);
%     end
% end


chosenFrequencies = freq;
indexesChosenFrequencies = ismember(f,freq);

duplicates = [];
i=1;
for m=1:length(freq)-1
    if (freq(m)==freq(m+1))
        duplicates(i) = freq(m);
        i = i+1;
    end
end

duplicateLimits = find(ismember(f,duplicates));
frequencyLimits = find(indexesChosenFrequencies);

frequencyLimits = [frequencyLimits duplicateLimits];
frequencyLimits = sort(frequencyLimits);

for k=1:length(frequencyLimits)/2
    indexesChosenFrequencies(frequencyLimits(2*k-1):frequencyLimits(2*k)) = 1;
end

neuralNetInput = zeros(numDivisions*2, size(rawInput,2));
    for plotIndex = 1:3
subplot(3,1,plotIndex);

for k=1:numDivisions
    hold on;
%     plot(greenFrequencies(indexes(k*2-1):indexes(k*2)), greenValues(plotIndex,indexes(k*2-1):indexes(k*2)),'.')
    neuralNetInput(k,:) = mean(rawInput(frequencyLimits(2*k-1):frequencyLimits(2*k) ,:),1);
    neuralNetInput(numDivisions+k,:) = std(rawInput(frequencyLimits(2*k-1):frequencyLimits(2*k) ,:),0,1);
end

this.input.(var) = neuralNetInput;
this.frequencyDivisions.(var) = chosenFrequencies;
this.indexesChosenFrequencies.(var) = indexesChosenFrequencies;
    end
hold off;
end

end