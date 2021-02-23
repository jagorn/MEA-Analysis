load(getDatasetMat, 'classesTableNotPruned', 'experiments');

for exp_id = [experiments{:}]
    for class_id = [classesTableNotPruned.name]
        if sum(classExpIndices(class_id, exp_id)) >= 4
            plotClassMosaicStats(class_id, exp_id);
            saveas(gcf, strcat(regexprep(class_id, '\.', ','), '-', exp_id', '_MOSAIC'),'jpg')
            close
        end
    end
end
    