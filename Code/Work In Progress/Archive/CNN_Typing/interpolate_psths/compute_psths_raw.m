clear

% Experimental parameters
params.meaRate = 20000;  % Hz
params.psth.tBin = 0.05; % s

% load Giulio's data generated with CNN models
load("_data/cnn_data.mat", "cell_id", "generated_psths");
indices_Giulio = cell_id + 1; % in python indices start by 0, in matlab by 1.

% load the table with the indexing used by Giulio in his CNN data
changeDataset("giulio")
load(getDatasetMat, "cellsTable");
experiments = {"20170614_noDH", "20180209", "20180705", "20181017", "20181018a", "20181018b"};

% for each experiment, generate the indices of the cells used by Giulio 
% and the respective PSTHs
indices_Giulio_by_experiment = cell(1, numel(experiments));
for i_exp = 1:numel(experiments)
    exp_id = experiments{i_exp};
    indices_exp = indices_Giulio([cellsTable(indices_Giulio).experiment] == exp_id);
    cells_Ns = [cellsTable(indices_exp).N];
    indices_Giulio_by_experiment{i_exp} = cells_Ns;
end

psths_raw = cell(1, numel(experiments));
for i_exp = 1:numel(experiments)
    disp(strcat("Experiment #", string(i_exp)))
    exp_id = experiments{i_exp};

    %----- PATHS ---------------------------%
    spikesMat = strcat(dataPath(), "/", exp_id, "/processed/SpikeTimes.mat");
    repetitionsMat = strcat(dataPath(), "/", exp_id, "/processed/Euler/Euler_RepetitionTimes.mat");

    %----- LOADs -------------------------------%
    load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
    load(spikesMat, "SpikeTimes")

    %----- PSTH CELLS ---------------------------------------%
    % modeling parameters
    nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1) + params.meaRate;
    binSize = params.psth.tBin * params.meaRate;
    nTBins = round(nSteps / binSize);
    
    [PSTH_neurons, ~, ~] = doPSTH(SpikeTimes, rep_begin_time_20khz, binSize, nTBins, params.meaRate, indices_Giulio_by_experiment{i_exp});
    
    
    %----- DEFINE FEATURES ---------------------------% 
    psths_raw{i_exp} = PSTH_neurons;
end
save("psths_raws", "psths_raw")
