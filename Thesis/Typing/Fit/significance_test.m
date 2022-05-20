load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat');
class_names = {'RGC.8.2.1.', 'RGC.8.2.4_PRUNED.', 'RGC.4.4.', 'RGC.3.8.', 'RGC.4.2.', 'RGC.2.5.', 'RGC.1.1.', 'RGC.1.3.1.', 'RGC.3.1.', 'RGC.3.2.2.', 'RGC.6.3.1.'};


for i_c = 1:numel(class_names)
    
    class_name = class_names{i_c};
    class_folder = strcat('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/', class_name, '_whole.mat');
    load(class_folder, 'params_both', 'params_sta');
    
    symbol_id = strcmp(class_name, names);
    symbol = symbols(symbol_id);
    color = colors(symbol_id, :);
    
    n_p = size(params_both, 2);
    
    fprintf("Type %s:\n", symbol);
    for i_p = 1:n_p
        [h, p] = ttest2(params_both(:, i_p), params_sta(:, i_p));
        if h
            fprintf("\tP%i: test SUCCEEDED with p-val %f\n", i_p, p);
        else
            fprintf("\tP%i: test FAILED with p-val %f\n", i_p, p);
        end
    end
    
    x = [params_both; params_sta];
    y = zeros(1, size(params_both, 1) + size(params_sta, 1));
    y(1:size(params_both, 1)) = 1;
    
    [d,p,stats] = manova1([x] , [y]);
    fprintf("\tManova Test: %f\n", p);
    fprintf("\n");
end