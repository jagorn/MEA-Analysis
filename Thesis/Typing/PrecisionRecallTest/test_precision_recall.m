load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/PrecisionRecallTest/CNNMatrix.mat', 'mosaicsTable', 'classesTableNotPruned', 'cellsTable')
cnn_table = mosaicsTable;
cnn_classes = classesTableNotPruned;
cnn_cells = cellsTable;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/PrecisionRecallTest/RGCMatrix.mat', 'mosaicsTable', 'classesTableNotPruned', 'cellsTable')
rgc_table = mosaicsTable;
rgc_classes = classesTableNotPruned;
rgc_cells = cellsTable;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/PrecisionRecallTest/STAMatrix.mat', 'mosaicsTable', 'classesTableNotPruned', 'cellsTable')
sta_table = mosaicsTable;
sta_classes = classesTableNotPruned;
sta_cells = cellsTable;


for i = 1:numel(sta_table)
    
    max_mcc = 0;
    max_prec = 0;
    max_recall = 0;
    size_candidate = 0;
    name = "";
          
    exp = sta_table(i).experiment;
    
    for i_rgc = 1:numel(rgc_classes)
        
        exp_indices = [rgc_cells.experiment] == exp;
        class_indices = rgc_classes(i_rgc).indices;
        class_exp_indices = exp_indices & class_indices;
        
        try
            [mcc, precision, recall] = mcc_score(sta_table(i).indices, class_exp_indices);
            if mcc > max_mcc
                max_mcc = mcc;
                max_prec = precision;
                max_recall = recall;
                size_candidate = sum(class_exp_indices);
                name = rgc_classes(i_rgc).name;
            end
        catch
        end
    end
    
    sta_table(i).RGC_Equivalent = name;
    sta_table(i).RGC_size = size_candidate;
    sta_table(i).MCC = max_mcc;
    sta_table(i).Precision = max_prec;
    sta_table(i).Recall = max_recall;
    
end



for i = 1:numel(cnn_table)
    
    max_mcc = 0;
    max_prec = 0;
    max_recall = 0;
    size_candidate = 0;
    name = "";
          
    exp = cnn_table(i).experiment;
    
    for i_rgc = 1:numel(rgc_classes)
        
        exp_indices = [rgc_cells.experiment] == exp;
        class_indices = rgc_classes(i_rgc).indices;
        class_exp_indices = exp_indices & class_indices;
        
        try
            [mcc, precision, recall] = mcc_score(cnn_table(i).indices, class_exp_indices);
            if mcc > max_mcc
                max_mcc = mcc;
                max_prec = precision;
                max_recall = recall;
                size_candidate = sum(class_exp_indices);
                name = rgc_classes(i_rgc).name;
            end
        catch
        end
    end
    
    cnn_table(i).RGC_Equivalent = name;
    cnn_table(i).RGC_size = size_candidate;
    cnn_table(i).MCC = max_mcc;
    cnn_table(i).Precision = max_prec;
    cnn_table(i).Recall = max_recall;
    
end


