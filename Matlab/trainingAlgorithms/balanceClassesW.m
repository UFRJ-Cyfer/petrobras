function [ewP, ew] = balanceClassesW(trainIndex, totalSamples, classDivider)

%totalSamples = length(trainIndex) + length(valIndex) + length(testIndex);

% Using training data set
ewP = zeros(1,length(classDivider));
ew = zeros(1, totalSamples);

samples = {};

for k=1:(length(classDivider))
	samples{k} = (trainIndex <= classDivider(k));

	if (k>=2)
		samples{k} = samples{k} - samples{k-1};
	end


	ewP(k) = sum(samples{k});
end

ewP(end+1) = sum(trainIndex > classDivider(end));

ewP = max(ewP)./ewP;

for k=1:(length(classDivider))
	ew(1:classDivider(k)) = ew(1:classDivider(k)) + ewP(k);

	if (k>=2)
		ew(1:classDivider(k-1)) = ew(1:classDivider(k-1)) - ewP(k);
	end

end
ew(classDivider(end)+1:end) = ew(classDivider(end)+1:end) + ewP(end);


end