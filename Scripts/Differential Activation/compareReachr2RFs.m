plot_path = '/home/fran_tr/Plots/20201125_reachr2_RF_comparison_Cell#';
dataset_id = "20201125_reachr2_noSTAs";
exp_id = "20201125_reachr2";
condition = 'LA20nd50p';

changeDataset(dataset_id);
loadDataset();

% exclude all cells still active at cnqxcpp
good_cells_idx = ~activations.flicker.lap4_acet_cnqxcpp_nd20p50.off.z & ~activations.flicker.lap4_acet_cnqxcpp_nd20p50.on.z;
good_cells = [cellsTable(good_cells_idx).N];
bad_cells = [cellsTable(~good_cells_idx).N];

% among the good cells, find the ones that have a RF before & after pharma application
[temporal_bf_pharma, spatial_bf_pharma, rfs_bf_pharma, good_stas_bf_pharma] = getSTAsComponents("20201125_reachr2");
[temporal_af_pharma, spatial_af_pharma, rfs_af_pharma, good_stas_af_pharma] = getSTAsComponents("20201125_reachr2", 'Label', 'LA20nd50p');

% exclude also cells with receptive fields too small (they are probably just noise).
min_area  = 3;
good_RF_af_pharma = intersect(good_stas_af_pharma, find(area(rfs_af_pharma) > min_area));
good_RF_bf_pharma = intersect(good_stas_bf_pharma, find(area(rfs_bf_pharma) > min_area));
good_RF_all = intersect(good_RF_bf_pharma, good_RF_af_pharma);

% compare the Receptive Fields
cells_for_comparison = intersect(good_RF_all, good_cells)'

% Plot the receptive field comparisons
% for cell_id = cells_for_comparison
%     plotComparisonExpSTA(exp_id, cell_id, condition);
%         export_fig(strcat(plot_path, num2str(cell_id)), '-svg');
%         close()
% end

% How many of my cells with no response on the control have a receptive field after pharma?
n_good_cells = numel(good_cells)
n_good_cells_rf_af_pharma = numel(intersect(good_cells, good_RF_af_pharma))

percentage_good_cells_with_RF_after_pharma = numel(intersect(good_cells, good_RF_af_pharma))/ numel(good_cells) * 100

% convert in microns
for i = 1:numel(rfs_af_pharma)
    rfs_af_pharma(i).Vertices = rfs_af_pharma(i).Vertices * 50;
    rfs_bf_pharma(i).Vertices = rfs_bf_pharma(i).Vertices * 50;
end

% how different are the receptive field sizes in leaked cells?
sizes_RFs_af_pharma = area(rfs_af_pharma(good_RF_af_pharma));
sizes_RFs_bf_pharma = area(rfs_bf_pharma(good_RF_bf_pharma));

n_good_bp = numel(good_RF_bf_pharma)
n_good_ap = numel(good_RF_af_pharma)

% plot
figure()
x = [sizes_RFs_bf_pharma, sizes_RFs_af_pharma];
g1 = repmat({'RF Size Normal'}, numel(sizes_RFs_bf_pharma), 1);
g2 = repmat({'RF Size Leaked Opsin'}, numel(sizes_RFs_af_pharma), 1);
boxplot(x, [g1; g2])
ylabel("RF sizes (square microns)");


% plot some examples of cells with changing receptive field
cell_examples = intersect(good_RF_bf_pharma, good_RF_af_pharma)';
for cell_id = cell_examples
    plotComparisonExpSTA(exp_id, cell_id, condition);
%     export_fig(strcat(plot_path, num2str(cell_id)), '-svg');
%     close()
end