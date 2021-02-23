% changeDataset("CNN")
load(getDatasetMat, "classesTableNotPruned");
classes = [classesTableNotPruned([classesTableNotPruned.size] > 3).name];

for class = classes
    
%     changeDataset("CNN")
%     cnn_indices = classIndices(class);
%     match_title = strcat(class, "_euler");
%     
%     changeDataset("RGC");
%     plotIndicesCard(match_title, cnn_indices);
%     saveas(gcf, regexprep(match_title, '\.', ','),'jpg')

    plotClassCard(class)
    saveas(gcf, regexprep(class, '\.', ','),'jpg')
    close;
end