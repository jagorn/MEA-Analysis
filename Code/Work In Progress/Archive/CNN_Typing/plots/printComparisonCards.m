load("classes_comparison.mat", "comparison_total");
classComparisonTable = comparison_total;

changeDataset("RGC")
printLeafCards

num_matches = numel(classComparisonTable);
for i_match = 1:num_matches

    changeDataset("CNN")
    cnn_type = classComparisonTable(i_match).CNN;
    cnn_indices = classIndices(cnn_type);
    
    changeDataset("RGC")
    rgc_type = classComparisonTable(i_match).RGC;
    rgc_indices = classIndices(rgc_type); 
    
    intersection_indices = cnn_indices & rgc_indices;
    union_indices = cnn_indices | rgc_indices;
    only_rgc_indices = (rgc_indices - cnn_indices) > 0;
    only_cnn_indices = (cnn_indices - rgc_indices) > 0;
    
    match_title = strcat(rgc_type, "_match");
    plotIndicesCard(match_title, cnn_indices);
    saveas(gcf, regexprep(match_title, '\.', ','),'jpg')
    close;

    intersection_title = strcat(rgc_type, "_intersection");
    plotIndicesCard(intersection_title, intersection_indices);
    saveas(gcf, regexprep(intersection_title, '\.', ','),'jpg')
    close;
    
    union_title = strcat(rgc_type, "_union");
    plotIndicesCard(union_title, union_indices);
    saveas(gcf, regexprep(union_title, '\.', ','),'jpg')
    close;    
    
    only_rgc_title = strcat(rgc_type, "_only_RGC");
    plotIndicesCard(only_rgc_title, only_rgc_indices);
    saveas(gcf, regexprep(only_rgc_title, '\.', ','),'jpg')
    close;

    only_cnn_title = strcat(rgc_type, "_only_cnn");
    plotIndicesCard(only_cnn_title, only_cnn_indices);
    saveas(gcf, regexprep(only_cnn_title, '\.', ','),'jpg')
    close;

end