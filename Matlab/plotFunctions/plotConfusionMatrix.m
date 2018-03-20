function figHandle = plotConfusionMatrix(confusion, labels)
%PLOTCONFUSIONMATRIX Plots the confusion matrix with the help of heatmap

    figure;
    for j=1:size(confusion,2)
        for k=1:size(confusion,1)
            if k~=j
                confusion(k,j) = -confusion(k,j);
            end
        end
    end
 
    figHandle = heatmap(confusion, labels, labels,...
        1 , 'Colormap','money','ShowAllTicks',1,'UseLogColorMap',false,'Colorbar',true);
    title('Confusion Matrix')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

end