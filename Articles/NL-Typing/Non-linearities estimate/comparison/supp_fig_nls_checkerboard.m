clear
close all
clc

do_save = true;

classes_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/classes_tables.mat";
mosaics_file = "/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat";
models_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/ln_models.mat";
color_file = "/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat";
my_class_suffix = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/_data/lns_";

load(classes_file, 'classesTableNotPruned', 'classesTableNotPrunedRF');
load(mosaics_file, 'mosaicsTable');
load(models_file, 'models_chirp', 'models_checks');
load(color_file, 'names', 'colors', 'symbols');

my_mosaics = ["RGC.8.2.1.", "RGC.8.2.4_PRUNED.", "RGC.4.4.", "RGC.3.8."];
use_only_cells_from_mosaics = true;
models = {models_chirp models_checks};  % models_chirp or model_checks;
model_names = ["chirp", "checks"];

for i_model = 1:numel(models)
    model = models{i_model};
    model_name = model_names(i_model);
    
    figure();
    i_plot = 0;
    for i_class = 1:numel(my_mosaics)
        
        class_name = my_mosaics(i_class);
        class_id = strcmp(class_name, [mosaicsTable.class]);
        
        if use_only_cells_from_mosaics
            chirp_idx = mosaicsTable(class_id).indices;
            rf_idx = mosaicsTable(class_id).controlIndices;
        else
            chirp_class_names = [classesTableNotPruned.name];
            rf_class_names = [classesTableNotPrunedRF.name];
            rf_class_name = mosaicsTable(class_id).bestControl;
            
            chirp_idx = classesTableNotPruned(strcmp(class_name, chirp_class_names)).indices;
            rf_idx = classesTableNotPrunedRF(strcmp(rf_class_name, rf_class_names)).indices;
        end
        
        core_idx = find(rf_idx & chirp_idx);
        residual_idx = find(rf_idx & ~chirp_idx);
        
        mosaic_id = strcmp(class_name, names);
        symbol = symbols(mosaic_id);
        color = colors(mosaic_id, :);
        
        nl_x = sort(unique([model.nl_x]));
        nls_residual_all = nan(numel(nl_x), numel(residual_idx));
        nls_core_all = nan(numel(nl_x), numel(core_idx));
        
        for i_nl = 1:numel(residual_idx)
            try
                i_r = residual_idx(i_nl);
                nl_r = model(i_r).nl_y;
                nl_x_r = model(i_r).nl_x;
                idx_r = sum(nl_x_r >= nl_x');
                nls_residual_all(idx_r, i_nl) = nl_r;
            end
        end
        
        nls_residual_valid = all(~isnan(nls_residual_all), 2);
        nls_residual = nls_residual_all(nls_residual_valid, :);
        nls_residual_x = nl_x(nls_residual_valid);
        n_residual = numel(residual_idx);

        for i_nl = 1:numel(core_idx)
            try
                i_c = core_idx(i_nl);
                nl_c = model(i_c).nl_y;
                nl_x_c = model(i_c).nl_x;
                idx_c = sum(nl_x_c >= nl_x');
                nls_core_all(idx_c, i_nl) = nl_c;
            end
        end
        
        nls_core_valid = all(~isnan(nls_core_all), 2);
        nls_core = nls_core_all(nls_core_valid, :);
        nls_core_x = nl_x(nls_core_valid);
        n_core = numel(core_idx);
        
        fprintf("\nnl residuals for model %s, class %s\n", model_name, class_name);
        nls_residual_all'
        
        fprintf("\nnl cores for model %s, class %s\n", model_name, class_name);
        nls_core_all'
        
        my_class_mat = strcat(my_class_suffix, class_name, "_", model_name, ".mat");
        
        if(do_save)
            save(my_class_mat, 'nls_core', 'nls_core_x', 'nls_residual', 'nls_residual_x');
        end
        
        % plot
        i_plot = i_plot + 1;
        subplot(2, 2, i_plot);
        hold on
        k = plot_std_surface(nls_residual', nls_residual_x, 'k');
        r = plot_std_surface(nls_core', nls_core_x, color);
        
        xlim([min(nl_x), max(nl_x)]);
        ylim([-0.1, 1.1]);
        
        xlabel('Generator signal');
        ylabel('Spiking Probability');
        
        title(strcat("Cluster ", symbol, " (", class_name, ")"), 'Interpreter', 'None')
        legend([k, r], {strcat('Cells only in STA mosaic (', num2str(n_residual), ')'), strcat('Cells in both mosaics (', num2str(n_core), ')')}, 'location', 'northwest')
    end
    suptitle(strcat(model_name, ": average non-linearities"));
end
