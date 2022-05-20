exp_single_rbcs = '20200131_rbc';
exp_multi_rbcs = '20170614_rbc';
exp_ctrl_rbcs = '20191011_grid';

exp_single_a2 = '20210804a_a2';
exp_ctrl_a2 = '20210721_grid';

exp_id = exp_ctrl_a2;
tags = getTags(exp_id);

[~, ~, ~, ~, good_stas] = getMEASTAs(exp_id);
good_cells = find(tags>3);
good_stas_cells = intersect(good_stas, good_cells);

n_templates = numel(tags)
n_cell = numel(good_cells)
n_sta_cells = numel(good_stas_cells)

[distances_disc, valid_stas] = getCell2DMDStimDistances(exp_id, 4);
surround_cells = find(distances_disc > 0);
good_surround_cells = intersect(good_stas_cells, surround_cells);
n_surround_cells = numel(good_surround_cells)
