clear
close all
clc

% Parameters
effective_rate = 30;
experiments = ["20170614_noDH", "20180209" "20180705" "20181017" "20181018a" "20181018b"];

% Paths
data_path = "/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/";
results_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/ln_models.mat";
table_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Classification/typing_results.mat";
load(table_file, 'mosaicsTable', 'cellsTable');

% Initialize structures
models_chirp = [];
models_checks = [];
psths_chirp = [];
psths_checks = [];

for exp_id = experiments
    
    fprintf("processing experiment %s...\n", exp_id);
    
    % Load Data By Experiment
    exp_file_spikes = fullfile(data_path, strcat(exp_id, ".mat"));
    exp_file_checker = fullfile(data_path, strcat("checker_reps_", exp_id, ".mat"));
    exp_file_stas = fullfile(data_path, strcat(exp_id, "_stas.mat"));
    
    load(exp_file_spikes, 'mea_rate', 'rep_begin', 'SpikeTimes', 'Valid_STAs_idx');
    load(exp_file_stas, 'temporal', 'spatial');
    
    % Get stimuli
    [chirp, chirp_rep_begin, chirp_rep_end] = getChirpStim(exp_file_spikes, mea_rate, effective_rate);
    [checks, checks_rep_begin, checks_rep_end] = getCheckerboardStim(exp_file_checker, mea_rate, effective_rate);
    
    % Get all cells from experiment   
    exp_idx = [cellsTable([cellsTable.experiment] == exp_id).N];
    
    % Find cells from experiment belonging to valid mosaics
    cell_idx = false;
    mosaic_idx = find(strcmp([mosaicsTable.experiment], exp_id));
    for i_m = mosaic_idx
        cell_idx = mosaicsTable(i_m).indices | cell_idx;
    end
    mosaics_idx = [cellsTable(cell_idx).N];
    
    if ~isempty(exp_idx)
        % Compute Non-linearities
        m_chirp = computeNL(SpikeTimes, temporal, chirp, ...
            effective_rate, chirp_rep_begin, chirp_rep_end, ...
            'Cell_Idx', exp_idx, 'Experiment', exp_id);
        m_checks = computeNL(SpikeTimes, temporal, checks, ...
            effective_rate, checks_rep_begin, checks_rep_end, ...
            'Cell_Idx', exp_idx, 'Experiment', exp_id, 'S_Filters', spatial);
        
        models_chirp = [models_chirp, m_chirp];
        models_checks = [models_checks, m_checks];
    end
end

save(results_file, 'models_chirp', 'models_checks', 'psths_chirp', 'psths_checks');


