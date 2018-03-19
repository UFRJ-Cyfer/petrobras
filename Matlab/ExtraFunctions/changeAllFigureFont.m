ah = findobj('Type','figure'); % get all figures
for m=1:numel(ah) % go over all axes
  set(findall(ah(m),'-property','FontSize'),'FontSize',12)
%    axes_handle = findobj(ah(m),'type','axes');
%   ylabel_handle = get(axes_handle,'ylabel');
%   saveas(ah(m),['pressao_TOFD' '.png'])
end