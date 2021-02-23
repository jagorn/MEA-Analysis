
tresh_coeff_up = 5;
tresh_coeff_down = 5;

tresh_fixed_up = 150;     % Hz
tresh_fixed_down = 55;   % Hz
thresh_baseline_fr = 50; % Hz

loadDataset();
[n_cells, n_discs, n_bins] = size(discs.psths);

thresh_spike_count = discs.params.time_bin * thresh_baseline_fr;
discs.avg_base = mean(discs.baselines, 2);
  
var_thresh_idx = discs.avg_base > thresh_spike_count;
fix_thresh_idx = discs.avg_base <= thresh_spike_count;

bases = mean(discs.baselines, 2);
sigmas = std(discs.baselines, [], 2);

discs.tresh_up(var_thresh_idx) = bases(var_thresh_idx) + tresh_coeff_up * sigmas(var_thresh_idx);
discs.tresh_down(var_thresh_idx) = bases(var_thresh_idx) - tresh_coeff_down * sigmas(var_thresh_idx);
discs.tresh_down(var_thresh_idx) = max(discs.tresh_down(var_thresh_idx), 0);

discs.tresh_up(fix_thresh_idx) = bases(fix_thresh_idx) + tresh_fixed_up * discs.params.time_bin;
discs.tresh_down(fix_thresh_idx) = bases(fix_thresh_idx) - tresh_fixed_down * discs.params.time_bin;

 discs.activations = cell(n_cells, n_discs);
 discs.suppressions = cell(n_cells, n_discs);
for i_cell = 1:n_cells
    
    tresh_up = discs.tresh_up(i_cell);
    tresh_down = discs.tresh_down(i_cell);
    
    for i_disc = 1:n_discs
        psth = squeeze(discs.psths(i_cell, i_disc, :));

        activations_idx = false(1, n_bins);
        suppressions_idx = false(1, n_bins);
        for i_bin = 2:n_bins
            activations_idx(i_bin) = (psth(i_bin) >= tresh_up) &  (psth(i_bin-1) < tresh_up);
            suppressions_idx(i_bin) = (psth(i_bin) <= tresh_down) &  (psth(i_bin-1) > tresh_down);    

        end
        discs.activations{i_cell, i_disc} = discs.t_psths(activations_idx);
        discs.suppressions{i_cell, i_disc} = discs.t_psths(suppressions_idx);
        
        discs.g2w{i_cell, i_disc} = discs.activations{i_cell, i_disc}(discs.dt_white1(1) < discs.activations{i_cell, i_disc} & discs.dt_white1(2) > discs.activations{i_cell, i_disc}) - discs.dt_white1(1);
        discs.w2b{i_cell, i_disc} = discs.activations{i_cell, i_disc}(discs.dt_black2(1) < discs.activations{i_cell, i_disc} & discs.dt_black2(2) > discs.activations{i_cell, i_disc}) - discs.dt_black2(1);
        discs.b2w{i_cell, i_disc} = discs.activations{i_cell, i_disc}(discs.dt_white3(1) < discs.activations{i_cell, i_disc} & discs.dt_white3(2) > discs.activations{i_cell, i_disc}) - discs.dt_white3(1);
        discs.w2g{i_cell, i_disc} = discs.activations{i_cell, i_disc}(discs.dt_background4(1) < discs.activations{i_cell, i_disc} & discs.dt_background4(2) > discs.activations{i_cell, i_disc}) - discs.dt_background4(1);
        
        if ~isempty(discs.g2w{i_cell, i_disc})
            discs.g2w{i_cell, i_disc} = discs.g2w{i_cell, i_disc}(1); 
        end
        if ~isempty(discs.w2b{i_cell, i_disc})
            discs.w2b{i_cell, i_disc} = discs.w2b{i_cell, i_disc}(1);
        end
        if ~isempty(discs.b2w{i_cell, i_disc})
            discs.b2w{i_cell, i_disc} = discs.b2w{i_cell, i_disc}(1);
        end
        if ~isempty(discs.w2g{i_cell, i_disc})
            discs.w2g{i_cell, i_disc} = discs.w2g{i_cell, i_disc}(1);
        end
        
        discs_reps(i_disc).id
    end
end
    
save(getDatasetMat, 'discs', '-append');
