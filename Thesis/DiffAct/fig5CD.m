clear
close all

% parameters
exclude_leaked_cells = true;
n_trials_variance_sampling = 100;
n_samples_variance_sampling = 20;


% compare variance explained in euler PCAs
dataset_ids = ["20210301_reachr2_noSTAs" "20210302_reachr2_noSTAs"];
condition_pharma = "lap4_acet_30nd100p";
condition_control = "lap4_acet_cnqxcpp_30nd100p";

figure();
variances_simple = zeros(numel(dataset_ids), 19);
variances_pharma = zeros(numel(dataset_ids), 19);


for i_dataset = 1:numel(dataset_ids)
    dataset_id = dataset_ids(i_dataset);
    
    changeDataset(dataset_id);
    loadDataset();
    n_cells = numel(cellsTable);
    
    good_cells_euler_bf_pharma = activations.euler.simple.on.z | activations.euler.simple.off.z;
    good_cells_euler_af_pharma = activations.euler.(condition_pharma).on.z | activations.euler.(condition_pharma).off.z;
    
    % choose wether to eliminate leaked cells or not
    leaking_cells = activations.flicker.(condition_control).on.z | activations.flicker.(condition_control).off.z;
    if exclude_leaked_cells
        good_cells_euler_bf_pharma = good_cells_euler_bf_pharma & ~leaking_cells;
        good_cells_euler_af_pharma = good_cells_euler_af_pharma & ~leaking_cells;
    end
    
    good_cells_always = good_cells_euler_bf_pharma & good_cells_euler_af_pharma;
    
    n_good_both = sum(good_cells_always)
    n_good_bf_pharma = sum(good_cells_euler_bf_pharma)
    n_good_af_pharma = sum(good_cells_euler_af_pharma)
    
    
    z_on_control = activations.flicker.simple.on.z;
    z_off_control = activations.flicker.simple.off.z;
    
    ONCells = z_on_control & ~z_off_control;
    OFFCells = z_off_control & ~z_on_control;
    Others = ~ONCells & ~OFFCells;
    
    % rand sample the populations of cells to have populations of comparable size.
    n_samples = min(n_samples_variance_sampling, min(n_good_bf_pharma, n_good_af_pharma))
    
    explained_simple_avg = 0;
    explained_pharma_avg = 0;
    
    for i = 1:n_trials_variance_sampling
        all_indices_bf_pharma = find(good_cells_euler_bf_pharma);
        all_indices_af_pharma = find(good_cells_euler_af_pharma);
        
        indices_bf_pharma = all_indices_bf_pharma(randperm(n_good_bf_pharma, n_samples));
        indices_af_pharma = all_indices_af_pharma(randperm(n_good_af_pharma, n_samples));
        
        psth_simple_all = psths.euler.simple.psths(indices_bf_pharma, :);
        psth_cond_all = psths.euler.(condition_pharma).psths(indices_af_pharma, :);
        
        [coeff, score, latent, tsquared, explained_simple, mu] = pca(psth_simple_all);
        [coeff, score, latent, tsquared, explained_pharma, mu] = pca(psth_cond_all);
        
        explained_simple_avg = explained_simple_avg + explained_simple/n_trials_variance_sampling;
        explained_pharma_avg = explained_pharma_avg + explained_pharma/n_trials_variance_sampling;
    end
    
    % figure()
    subplot(1, 2, 1)
    hold on;
    plot(cumsum(explained_simple_avg), 'Color', [0, 0, 1, 0.4], 'LineWidth', 1.5);
    plot(cumsum(explained_pharma_avg), 'Color', [1, 0, 0, 0.4], 'LineWidth', 1.5);
    title('PCA in Euler Responses')
    ylabel('Variance Explained (%)')
    xlabel('Principal Components')
    xlim([0,20])
    
    variances_simple(i_dataset, :) = cumsum(explained_simple_avg);
    variances_pharma(i_dataset, :) = cumsum(explained_pharma_avg);
    
    % Compare PSTH correlations
    psth_simple = psths.euler.simple.psths(good_cells_always & (ONCells|OFFCells), :);
    psth_cond = psths.euler.(condition_pharma).psths(good_cells_always & (ONCells|OFFCells), :);
    
    corrs_coeff_simple  = corrcoef(psth_simple');
    corrs_simple = corrs_coeff_simple(triu(true(size(corrs_coeff_simple)), 1));
    
    corrs_coeff_cond  = corrcoef(psth_cond');
    corrs_cond = corrs_coeff_cond(triu(true(size(corrs_coeff_cond)), 1));
    
    % figure()
    subplot(1, 2, 2)
    hold on
    daspect([1 1 1])
    xlim([0 1])
    ylim([0 1])
    plot([0, 1], [0, 1], 'k--', 'LineWidth', 1.5)
%     plt_others = scatter(corrs_simple, corrs_cond, 30, [0.5 0.5 0.5], 'Filled');
    
    % Plot only ON-ON
    psth_simple_on = psths.euler.simple.psths(good_cells_always & ONCells, :);
    psth_cond_on = psths.euler.(condition_pharma).psths(good_cells_always & ONCells, :);
    corrs_coeff_simple_on  = corrcoef(psth_simple_on');
    corrs_simple_on = corrs_coeff_simple_on(triu(true(size(corrs_coeff_simple_on)), 1));
    corrs_coeff_cond_on  = corrcoef(psth_cond_on');
    corrs_cond_on = corrs_coeff_cond_on(triu(true(size(corrs_coeff_cond_on)), 1));
    plt_on = scatter(corrs_simple_on, corrs_cond_on, 30, 'r', 'Filled');
    
    
    % Plot only OFF-OFF
    psth_simple_off = psths.euler.simple.psths(good_cells_always & OFFCells, :);
    psth_cond_off = psths.euler.(condition_pharma).psths(good_cells_always & OFFCells, :);
    corrs_coeff_simple_off  = corrcoef(psth_simple_off');
    corrs_simple_off = corrs_coeff_simple_off(triu(true(size(corrs_coeff_simple_off)), 1));
    corrs_coeff_cond_off  = corrcoef(psth_cond_off');
    corrs_cond_off = corrs_coeff_cond_off(triu(true(size(corrs_coeff_cond_off)), 1));
    plt_off = scatter(corrs_simple_off, corrs_cond_off, 30, 'b', 'Filled');
    
    
%     l = legend([plt_on, plt_off, plt_others], 'ON vs ON', 'OFF vs OFF', 'ON vs OFF');
    l = legend([plt_on, plt_off], 'ON vs ON', 'OFF vs OFF');
    l.Location = 'Northwest';
    title('Correlations across Cell Reponses')
    xlabel('Normal')
    ylabel('Optogenetics')
    
    % USe t-Distributed Stochastic Neighbor Embedding to visualize features of ON and OFF after pharma.
    labelsOnOff = cell(sum(good_cells_always & (ONCells|OFFCells)), 1);
    for i_on = find(ONCells(good_cells_always & (ONCells|OFFCells)))
        labelsOnOff{i_on} = 'ON';
    end
    for i_on = find(OFFCells(good_cells_always & (ONCells|OFFCells)))
        labelsOnOff{i_on} = 'OFF';
    end
    for i_on = find(Others(good_cells_always & (ONCells|OFFCells)))
        labelsOnOff{i_on} = 'OTHER';
    end
end

subplot(1, 2, 1)
hold on
plot(mean(variances_simple), 'Color', [0, 0, 1, 1], 'LineWidth', 1.5);
plot(mean(variances_pharma), 'Color', [1, 0, 0, 1], 'LineWidth', 1.5);

legend({'Normal', 'Optogenetics'}, 'Location', 'southeast')
