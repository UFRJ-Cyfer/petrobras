function dividedInput = manualDivision(input,validFrequencies, frequencyDivisions)

if rem(length(frequencyDivisions),2) ~=0
    warning('The frequencyDivisions vector must be even sized')
    exit;   
end

numDivisions = length(frequencyDivisions)/2;

% input is of the shape ->  elements x samples

dividedInput = zeros(size(input,1), numDivisions);

for k=1:numDivisions
    dividedInput(k,:) = mean(input(frequencyDivisions(2*k-1):frequencyDivisions(2*k),:),1);
end


end
