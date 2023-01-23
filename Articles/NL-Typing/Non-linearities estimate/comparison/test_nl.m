clear;
close all;
clc;

% load
models_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/ln_models.mat";
load(models_file, 'models_chirp', 'models_checks');
n_cells = numel(models_chirp);

table_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Classification/typing_results.mat";
load(table_file, 'mosaicsTable', 'cellsTable');

% Find cells from experiment belonging to valid mosaics
cells_idx_logical = false;
for i_m = 1:numel(mosaicsTable)
    cells_idx_logical = mosaicsTable(i_m).indices | cells_idx_logical;
end
cell_idx = find(cells_idx_logical);

% initialize
min_chirp_nl_x = nan(n_cells, 1);
max_chirp_nl_x = nan(n_cells, 1);
numel_chirp_nl_x = nan(n_cells, 1);

min_check_nl_x = nan(n_cells, 1);
max_check_nl_x = nan(n_cells, 1);
numel_check_nl_x = nan(n_cells, 1);

pearson_chirp = nan(n_cells, 1);
pearson_check = nan(n_cells, 1);

for i_cell = cell_idx
    
    model_chirp = models_chirp(i_cell);
    model_check = models_checks(i_cell);
    
    exp_id = model_chirp.experiment;
    cell_id = model_chirp.n;
    
    % debug
    exp_id2 = model_check.experiment;
    cell_id2 = model_check.n;
    assert(exp_id == exp_id2);
    assert(cell_id == cell_id2);
        
    r_chirp = (model_chirp.r - min(model_chirp.r)) / (max(model_chirp.r)- min(model_chirp.r));
    r_check = (model_check.r - min(model_check.r)) / (max(model_check.r)- min(model_check.r));
    
    p_chirp = (model_chirp.psth - min(model_chirp.psth)) / (max(model_chirp.psth)- min(model_chirp.psth));
    p_check = (model_check.psth - min(model_check.psth)) / (max(model_check.psth)- min(model_check.psth));
    
    % debug
    x_chirp = model_chirp.x;
    x_check = model_check.x;
    
    try
    assert(~any(isnan(x_chirp)));
    assert(~any(isnan(x_check)));
    assert(~any(isnan(r_chirp)));
    assert(~any(isnan(r_check)));
    assert(~any(isnan(p_chirp)));
    assert(~any(isnan(p_check)));
    assert(~any(isnan(model_chirp.nl_x)));
    assert(~any(isnan(model_chirp.nl_y)));
    assert(~any(isnan(model_check.nl_x)));
    assert(~any(isnan(model_check.nl_y)));
    catch
        fprintf("problem with cell %i\n", i_cell);
        continue;
    end
    
    min_chirp_nl_x(i_cell) = min(model_chirp.nl_x);
    max_chirp_nl_x(i_cell) = max(model_chirp.nl_x);
    numel_chirp_nl_x(i_cell) = numel(model_chirp.nl_x);
    
    min_check_nl_x(i_cell) = min(model_check.nl_x);
    max_check_nl_x(i_cell) = max(model_check.nl_x);
    numel_check_nl_x(i_cell) = numel(model_check.nl_x);
    
    pear_mat_chirp = corrcoef(r_chirp, p_chirp);
    pearson_chirp(i_cell) = pear_mat_chirp(1, 2);
    
    pear_mat_check = corrcoef(r_check, p_check);
    pearson_check(i_cell) = pear_mat_check(1, 2);
end

mean_min_chirp_nl_x = mean(min_chirp_nl_x(~isnan(min_chirp_nl_x)));
mean_min_check_nl_x = mean(min_check_nl_x(~isnan(min_check_nl_x)));

mean_max_chirp_nl_x = mean(max_chirp_nl_x(~isnan(max_chirp_nl_x)));
mean_max_check_nl_x = mean(max_check_nl_x(~isnan(max_check_nl_x)));

mean_numel_chirp_nl_x = mean(numel_chirp_nl_x(~isnan(numel_chirp_nl_x)));
mean_numel_check_nl_x = mean(numel_check_nl_x(~isnan(numel_check_nl_x)));

mean_pearson_chirp = mean(pearson_chirp(~isnan(pearson_chirp)));
mean_pearson_check = mean(pearson_check(~isnan(pearson_check)));

fprintf("NL Domain ANALYSIS MIN: chirp=%f, check=%f, MAX: chirp=%f, check=%f, NUMEL: chirp=%f, check=%f\n", ...
        mean_min_chirp_nl_x, mean_min_check_nl_x, mean_max_chirp_nl_x, mean_max_check_nl_x, mean_numel_chirp_nl_x, mean_numel_check_nl_x);
    
fprintf("Average Domain Ratio chirp/check=%f\n", mean_numel_chirp_nl_x / mean_numel_check_nl_x);
fprintf("Average Pearson correlation: chirp=%f, check=%f\n", mean_pearson_chirp, mean_pearson_check);