plot_path = '/home/francesco/Plots/20201125_reachr2_RF_comparison_Cell#';
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
good_stas_before_pharma = printValidSTAs("20201125_reachr2");
good_stas_after_pharma = printValidSTAs("20201125_reachr2", 'Label', 'LA20nd50p');
good_stas_all = intersect(good_stas_before_pharma, good_stas_after_pharma);

cells_for_comparison = intersect(good_stas_all, bad_cells)

for cell_id = cells_for_comparison'
    plotComparisonExpSTA(exp_id, cell_id, condition);
    export_fig(strcat(plot_path, num2str(cell_id)), '-png');
    close()
end

