
% compare variance explained in euler PCAs
dataset_id = "20210302_reachr2_noSTAs";
% dataset_id = "20201125_reachr2_noSTAs";

condition = "lap4_acet_30nd100p"; 
% condition = "lap4_acet_nd30p50";

changeDataset(dataset_id);
loadDataset();

% exclude all cells still active at cnqxcpp
good_cells_idx = ~activations.flicker.lap4_acet_cnqxcpp_30nd100p.off.z & ~activations.flicker.lap4_acet_cnqxcpp_30nd100p.on.z;
% good_cells_idx = ~activations.flicker.lap4_acet_cnqxcpp_nd20p50.off.z & ~activations.flicker.lap4_acet_cnqxcpp_nd20p50.on.z;

good_cells_euler = activations.euler.simple.on.z | activations.euler.simple.off.z;
good_cells_total = good_cells_euler & good_cells_idx;
n_good_cells_total = sum(good_cells_total);

fprintf('good cells for cnqxcpp control: %i/%i;\n', sum(good_cells_idx), numel(good_cells_idx))
fprintf('good cells for euler activation: %i/%i;\n', sum(good_cells_euler), numel(good_cells_euler))
fprintf('good cells for euler & cnqxcpp: %i/%i;\n', sum(good_cells_total), numel(good_cells_total))

psth_simple = psths.euler.simple.psths(good_cells_total, :);
psth_cond = psths.euler.(condition).psths(good_cells_total, :);

[coeff, score, latent, tsquared, explained_simple, mu] = pca(psth_simple);
[coeff, score, latent, tsquared, explained_pharma, mu] = pca(psth_cond);

figure()
hold on;
plot(cumsum(explained_simple), 'b', 'LineWidth', 1.5);
plot(cumsum(explained_pharma), 'r', 'LineWidth', 1.5);
legend({'normal', 'resurrected'}, 'Location', 'southeast')
title('PCA in Euler Responses')
ylabel('Variance Explained (%)')
xlabel('Principal Components')
xlim([0,20])


figure();
psth_corr = zeros(1, n_good_cells_total);
for i_cell = 1:n_good_cells_total
    corr_matrix = corrcoef(psth_simple(i_cell, :), psth_cond(i_cell, :));
    
    corr_coeff = corr_matrix(1, 2);
    psth_corr(i_cell) = corr_coeff;
    
%     if psth_corr(i_cell) > 0.5
%         figure()
%         hold on
%         plot(psth_simple(i_cell, :), 'b');
%         plot(psth_cond(i_cell, :), 'r');
%         waitforbuttonpress()
%         close();
%     end
    
end
histogram(psth_corr, 20);
title('PSTH correlation');

