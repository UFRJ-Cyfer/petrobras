function [figHandles] = reportStreaming(this, language)
%  Creates several figures to report a StreamingClass object
%
%	:param language: Allows the user to select the language (not working).
%	:type language: String
%
%	:returns: A struct holding all figure handles.
units = {'',' (s)', '', ' (J)', ' (s)', '', ' (dB)', '', ' (dB)', '', '', '' , '', '', '', '', '' , '', '', ''};
WIDTH = 8;
HEIGHT = 8;
FONTSIZE = 11;

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
	language = 'en';
end


	for k=1:(length(fields)-3)
		status = mkdir(['Report/' this.description '\' fields{k}]);
	end
		status = mkdir(['Report/' this.description '\' 'CorrAnalysis']);


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
	ylabel('Count')
	set(gca,'FontSize', FONTSIZE)
	set(fig, 'Color', 'w');
	figHandles.figs(k) = fig;
    set(fig,'PaperUnits', 'centimeters', 'Units', 'centimeters',...
      'pos',[125 5 WIDTH HEIGHT]);
 	export_fig([savePath fields{k} '/Histogram' xlabelString(find(~isspace(xlabelString)))],'-pdf','-png')
% 	print([savePath fields{k} '/Histogram' xlabelString(find(~isspace(xlabelString)))],'-dpdf', '-r600')
	savefig([savePath fields{k}  '/Histogram' xlabelString(find(~isspace(xlabelString)))])

 	hold off;
 	histogram(data(this.spIndexes), 'BinEdges', bins, 'facecolor', map(1,:),'facealpha',.5,'edgecolor','none'); hold on;
 	histogram(data(this.peIndexes), 'BinEdges', bins, 'facecolor', map(2,:),'facealpha',.5,'edgecolor','none') 
 	histogram(data(this.piIndexes), 'BinEdges', bins, 'facecolor', map(3,:),'facealpha',.5,'edgecolor','none')
 	hold off;
	set(gca, 'SortMethod', 'ChildOrder');
    legend('NP', 'SP', 'UP')
	legend boxoff;
	xlabel(xlabelString)
	ylabel('Count')
	set(gca,'FontSize', FONTSIZE)
 	export_fig([savePath fields{k}  '/ClassesHistogram' xlabelString(find(~isspace(xlabelString)))],'-pdf')
	savefig([savePath fields{k}  '/ClassesHistogram' xlabelString(find(~isspace(xlabelString)))])

    if ~isempty(this.spIndexes) && ~isempty(this.peIndexes) && ~isempty(this.piIndexes)
        [h1,~] = histcounts(data(this.spIndexes), bins);
        [h2,~] = histcounts(data(this.peIndexes), bins);
        [h3,~] = histcounts(data(this.piIndexes), bins);
        ctrs = bins(1)+(1:length(bins)-1).*diff(bins);   % Create Centres
        bar(ctrs, [h1 ;h2; h3]')
    legend('NP', 'SP', 'UP')
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
	xlabel('Index')
	ylabel(ylabelString)
	set(gca,'FontSize', FONTSIZE)
	set(fig, 'Color', 'w');
	figHandles.figs(end+k) = fig;
    set(fig,'PaperUnits', 'centimeters', 'Units', 'centimeters',...
      'pos',[125 5 WIDTH HEIGHT]);
 	export_fig([savePath fields{k}  '/Index' ylabelString(find(~isspace(ylabelString)))],'-pdf')
	savefig([savePath fields{k}  '/Index' ylabelString(find(~isspace(ylabelString)))])

	plot( ([this.Waves.('triggerTime')]), ([this.Waves.(fields{k})]) ,'.')
    xlabel('Time (s)')
	ylabel(ylabelString)
	set(gca,'FontSize', FONTSIZE)
    set(gca, 'SortMethod', 'ChildOrder');
	export_fig([savePath fields{k}  '/Tempo' ylabelString(find(~isspace(ylabelString)))],'-pdf')
	savefig([savePath fields{k}  '/Tempo' ylabelString(find(~isspace(ylabelString)))])
end

this.StreamingModel = this.StreamingModel.plotCorrAnalysis();
% close all;
for k=1:length(this.StreamingModel.figHandles)
    figure(this.StreamingModel.figHandles(k))
    
    set(this.StreamingModel.figHandles(k),'PaperUnits', 'centimeters', 'Units', 'centimeters',...
      'pos',[125 5 WIDTH HEIGHT]);
  
    allAxesInFigure = findall(this.StreamingModel.figHandles(k),'type','axes');
   	set(allAxesInFigure,'FontSize', FONTSIZE,'FontName', 'Times')
    set(allAxesInFigure, 'SortMethod', 'ChildOrder');
    titleString = allAxesInFigure(3).Title.String;
 	export_fig([savePath 'CorrAnalysis' '/Tempo' titleString(find(~isspace(titleString)))],'-pdf')
	savefig([savePath 'CorrAnalysis' '/Tempo' titleString(find(~isspace(titleString)))])

end
end