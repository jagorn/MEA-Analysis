clear

% Parameters
% exp_id = '20190416_gtacr';
% flash.types = ["FLASHES", "FLASHES_40nd100p", "FLASHES_30nd100p", "FLASHES_20nd30p", "FLASHES_20nd100p0002"];

exp_id = '20200226_jaws';
flash.types = ["FLASH_500ms", "FLASH_1s", "FLASH_2s", "FLASH_5s"];


flash.bin_dt = 0.05;
flash_Z.k_zscore = 5;
flash_Z.min_firing_rate = 2;

% Load data
changeDataset(exp_id);
load(getDatasetMat(), 'spikes');

% Compute PSTH for each cells and flash type
for i_flash = 1:numel(flash.types)

    rep = getFlashRepeats(exp_id, flash.types(i_flash));
    
    bin_size = flash.bin_dt * rep.mea_rate;
    n_bins = round(rep.n_steps / bin_size);

    [flash.psth{i_flash}, flash.xpsth{i_flash}, ~, ~] = doPSTH(spikes, rep.begin, bin_size, n_bins, rep.mea_rate, 1:length(spikes));
    
    flash.ONCtrlWin(:, i_flash) = rep.ONCtrlWin;
    flash.ONRespWin(:, i_flash) = rep.ONRespWin;
    flash.OFFCtrlWin(:, i_flash) = rep.OFFCtrlWin;
    flash.OFFRespWin(:, i_flash) = rep.OFFRespWin;
    
    flash.FlashWin(:, i_flash) = rep.FlashWin;
    flash.PauseWin(:, i_flash) = rep.PauseWin;
    flash.dt(:, i_flash) = rep.dt;
    
    % estimate zscore
    [flash_Z.zON(:,i_flash), flash_Z.ThresON(:,i_flash)] = EstimateZscore(flash.psth{i_flash}, flash.xpsth{i_flash}, rep.ONCtrlWin, rep.ONRespWin, flash_Z.k_zscore, flash_Z.min_firing_rate);
    [flash_Z.zOFF(:,i_flash),flash_Z.ThresOFF(:,i_flash)] = EstimateZscore(flash.psth{i_flash}, flash.xpsth{i_flash}, rep.OFFCtrlWin, rep.OFFRespWin, flash_Z.k_zscore, flash_Z.min_firing_rate);
end
    
save(getDatasetMat(), 'flash', 'flash_Z', '-append')
