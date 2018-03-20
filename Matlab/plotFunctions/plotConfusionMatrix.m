function figHandle = plotConfusionMatrix(confusion, labels)
%PLOTCONFUSIONMATRIX Plots the confusion matrix with the help of heatmap

% The main diagonal (hits) get a green colour, while the other matrix
% elements (misses) turn negative so that the heatmap turns them red. This
% should be tinkered so that it doesn't show negative numbers tho.

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