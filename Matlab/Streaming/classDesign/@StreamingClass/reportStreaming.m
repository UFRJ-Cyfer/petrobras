function [figHandles] = reportStreaming(this, language)
%REPORTSTREAMING Creates several figures to report a streamingOBJ
units = {'',' (s)', '', ' (J)', ' (s)', '', ' (dB)', '', ' (dB)', '', '', '' , '', '', '', '', '' , '', '', ''};

FONTSIZE = 12;

fields = fieldnames(this.Waves); % this is a CELL ARRAY !!!!!
fields(1) = []; % removing rawData

for k=1:length(fields)-3 %excluding splitIndex, splitFile and relativeTriggerIndex
	xlabels{k} = [upper(fields{k,1}(1)) fields{k,1}(2:end)];
	xlabels{k} = (regexprep(xlabels{k}, '([A-Z])', ' $1'));
    xlabels{k}(1) = [];
end

xlabels{6} = 'RMS';
xlabels{7} = 'Max Amplitude';


map = brewermap(3,'Set1'); 
figHandles = struct();
figHandles.fields = fields;

if ~exist('language','var')
	language = 'pt';
end


% if exist([pwd '\Report'], 'dir')==0
	for k=1:(length(fields)-3)
		status = mkdir(['Report/' this.description '\' fields{k}]);
	end
% end

savePath = ['Report/' this.description '/'];


for k=1:(length(fields)-3) %excluding splitIndex, splitFile and relativeTriggerIndex
	fig = figure();
	data = [this.Waves.(fields{k})];
    if k > 1
	h = histogram(data,20);
    else
    h = histogram(data);
    end
    bins = h.BinEdges;
	xlabelString = [xlabels{k} units{k}]
	xlabel(xlabelString)
	ylabel('Frequency')
	set(gca,'FontSize', FONTSIZE)
	set(fig, 'Color', 'w');
	figHandles.figs(k) = fig;
	export_fig([savePath fields{k} '/Histogram' xlabelString(find(~isspace(xlabelString)))],'-pdf')
% 	print([savePath fields{k} '/Histogram' xlabelString(find(~isspace(xlabelString)))],'-dpdf', '-r600')
	savefig([savePath fields{k}  '/Histogram' xlabelString(find(~isspace(xlabelString)))])

 	hold off;
 	histogram(data(this.spIndexes), 'BinEdges', bins, 'facecolor', map(1,:),'facealpha',.5,'edgecolor','none'); hold on;
 	histogram(data(this.peIndexes), 'BinEdges', bins, 'facecolor', map(2,:),'facealpha',.5,'edgecolor','none') 
 	histogram(data(this.piIndexes), 'BinEdges', bins, 'facecolor', map(3,:),'facealpha',.5,'edgecolor','none')
 	hold off;
	set(gca, 'SortMethod', 'ChildOrder');
    legend('SP', 'PE', 'PI')
	legend boxoff;
	xlabel(xlabelString)
	ylabel('Frequency')
	set(gca,'FontSize', FONTSIZE)
	export_fig([savePath fields{k}  '/ClassesHistogram' xlabelString(find(~isspace(xlabelString)))],'-pdf')
	savefig([savePath fields{k}  '/ClassesHistogram' xlabelString(find(~isspace(xlabelString)))])

    if ~isempty(this.spIndexes) && ~isempty(this.peIndexes) && ~isempty(this.piIndexes)
        [h1,~] = histcounts(data(this.spIndexes), bins);
        [h2,~] = histcounts(data(this.peIndexes), bins);
        [h3,~] = histcounts(data(this.piIndexes), bins);
        ctrs = bins(1)+(1:length(bins)-1).*diff(bins);   % Create Centres
        bar(ctrs, [h1 ;h2; h3]')
        legend('SP', 'PE', 'PI')
        legend boxoff;
        xlabel(xlabelString)
        ylabel('Frequency')
        set(gca,'FontSize', FONTSIZE)
        set(gca, 'SortMethod', 'ChildOrder');
        export_fig([savePath fields{k}  '/ClassesBar' xlabelString(find(~isspace(xlabelString)))],'-pdf')
        savefig([savePath fields{k}  '/ClassesBar' xlabelString(find(~isspace(xlabelString)))])
    end
end

for k=1:length(fields)-3 %excluding splitIndex, splitFile and relativeTriggerIndex
	fig = figure();
	plot( ([this.Waves.(fields{k})]),'.')
	ylabelString = [xlabels{k} units{k}]
	xlabel('Índice')
	ylabel(ylabelString)
	set(gca,'FontSize', FONTSIZE)
	set(fig, 'Color', 'w');
	figHandles.figs(end+k) = fig;
	export_fig([savePath fields{k}  '/Index' ylabelString(find(~isspace(ylabelString)))],'-pdf')
	savefig([savePath fields{k}  '/Index' ylabelString(find(~isspace(ylabelString)))])

	plot( ([this.Waves.('triggerTime')]), ([this.Waves.(fields{k})]) ,'.')
    xlabel('Tempo (s)')
	ylabel(ylabelString)
	set(gca,'FontSize', FONTSIZE)
    set(gca, 'SortMethod', 'ChildOrder');
	export_fig([savePath fields{k}  '/Tempo' ylabelString(find(~isspace(ylabelString)))],'-pdf')
	savefig([savePath fields{k}  '/Tempo' ylabelString(find(~isspace(ylabelString)))])
end

% close all;

end