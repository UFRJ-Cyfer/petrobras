

savepath = 'E:\BACKUPJ\ProjetoPetrobras\Reunioes\12-01-2018\bomb\';
ah = findobj('Type','figure'); % get all figures
for m=1:numel(ah) % go over all axes
    set(findall(ah(m),'-property','FontSize'),'FontSize',12)
    axes_handle = findobj(ah(m),'type','axes');
    ylabel_handle = get(axes_handle,'ylabel');
    
      saveas(ah(m),[savepath ylabel_handle.String '' axes_handle.Title.String '.png'])
    %    saveas(ah(m),['nn_output' '.png'])
end