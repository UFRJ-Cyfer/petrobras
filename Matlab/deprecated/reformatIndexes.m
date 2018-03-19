function structIndexes = reformatIndexes ( indexesPerChannel, originalChannels )

structIndexes = [];

for channel = unique(originalChannels)
   if ~isempty(indexesPerChannel(channel).removeIndexes)
        locations = find(originalChannels == channel);
        structIndexes = [structIndexes locations(indexesPerChannel(channel).removeIndexes)];
   end
end

end