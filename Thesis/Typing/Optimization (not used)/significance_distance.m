clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

for entry = [14 15 12 10]  %1:numel(mosaicsTable)
    
    sta_classification_entry = mosaicsTable(entry);
    class_name = sta_classification_entry.class;
    
    i_sym = names == class_name;
    symbol = symbols(i_sym);
    color = colors(i_sym, :);
    
    hessian_file = strcat("Data_Fit/SigmoidFit_", symbol, ".mat");
    
    try
        load(hessian_file, 'params_sta', 'params_both', 'hessian_sta', 'hessian_both');
    catch
        fprintf("Warning: class %s not found.\n", symbol);
        continue;
    end
    
    n_cells_sta = numel(hessian_sta);
    n_cells_both = numel(hessian_both);
    
    dd_same = [];
    dd_different = [];

    for i_both = 1:n_cells_both
        
        h_both = hessian_both{i_both};
        p_both = params_both(i_both, :);
        
        for i_both2 = 1:n_cells_both
            if i_both == i_both2
                continue
            end
            
            h_both2 = hessian_both{i_both2};
            p_both2 = params_both(i_both2, :);

            dd_same = [dd_same hessian_distance(p_both, p_both2, h_both, h_both2)];
        end
        
        for i_sta = 1:n_cells_sta
            
            h_sta = hessian_sta{i_sta};
            p_sta = params_sta(i_sta, :);
            
            dd_different = [dd_different hessian_distance(p_both, p_sta, h_both, h_sta)];
        end
    end
    mean_diff = mean(dd_different);
    mean_same = mean(dd_same);
    p = ranksum(dd_different,dd_same);
    fprintf("Class %s: mean_same = %f, mean_diff = %f, p-val = %f.\n", symbol, mean_same, mean_diff, p);
end