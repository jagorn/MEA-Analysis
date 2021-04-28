clear

% Experimental parameters
params.meaRate = 20000;  % Hz
params.psth.tBin = 0.05; % s

% Clustering parameters RGC
c_params_STA.min_size = 7;
c_params_STA.split_size = 10;

c_params_STA.min_psth_SNR = 0;
c_params_STA.min_sta_SNR = .9;

c_params_STA.split_psth_SNR = 1;
c_params_STA.split_sta_SNR = .95;   

% Other parameters
dataset_label = "STA";
acceptedLabels = 3; % 5=A, 4=AB, 3=ABC

% load Giulio's data generated with CNN models
load("_data/cnn_data.mat", "cell_id", "generated_psths");
indices_Giulio = cell_id + 1; % in python indices start by 0, in matlab by 1.

% load the table with the indexing used by Giulio in his CNN data
changeDataset("giulio")
load(getDatasetMat, "cellsTable", "experiments");

% for each experiment, generate the indices of the cells used by Giulio 
% and the respective PSTHs
indices_Giulio_by_experiment = cell(1, numel(experiments));
psths_Giulio_by_experiment = cell(1, numel(experiments));

for i_exp = 1:numel(experiments)
    exp_id = experiments{i_exp};
    indices_exp = indices_Giulio([cellsTable(indices_Giulio).experiment] == exp_id);
    
    cells_Ns = [cellsTable(indices_exp).N];
    cells_psths = generated_psths([cellsTable(indices_Giulio).experiment] == exp_id, :);
    
    indices_Giulio_by_experiment{i_exp} = cells_Ns;
    psths_Giulio_by_experiment{i_exp} = cells_psths;
end

% Initialization
indices_list = {};
features_list = {};

temporalSTAs = [];
spatialSTAs = [];
stas = [];

psths_models = [];
psths_neurons = [];

for i_exp = 1:numel(experiments)
    disp(strcat("Experiment #", string(i_exp)))
    exp_id = experiments{i_exp};

    %----- PATHS ---------------------------%
    spikesMat = strcat(dataPath(), "/", exp_id, "/processed/SpikeTimes.mat");
    indicesMat = strcat(dataPath(), "/", exp_id, "/processed/Indices.mat");
    tagsMat = strcat(dataPath(), "/", exp_id, "/processed/Tags.mat");

    repetitionsMat = strcat(dataPath(), "/", exp_id, "/processed/Euler/Euler_RepetitionTimes.mat");
    stimMat = strcat(dataPath(), "/", exp_id, "/processed/Euler/Euler_Stim.mat");
    staMat = strcat(dataPath(), "/", exp_id, "/processed/STA/Sta.mat");

    %----- LOADs -------------------------------%
    load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
    load(stimMat, "euler", "euler_sampler_rate")
    load(spikesMat, "SpikeTimes")
    load(staMat, "STAs")
    
    try
        load(indicesMat, "indices")
    catch
        disp("INFO: INDICES NOT FOUND. USING ALL CELLS")
        indices = 1:numel(SpikeTimes);
    end
    
    try
        load(tagsMat, "Tags")
    catch
        disp("WARNING: TAGGES NOT FOUND. RATING ALL CELLS AS [A]")
        Tags = ones(numel(SpikeTimes), 1) * 5;
    end
    
    %----- PSTH MODELS --------------------------------%
    PSTH_models = psths_Giulio_by_experiment{i_exp};
    
    %----- PSTH CELLS ---------------------------------------%
    % modeling parameters
    nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1) + params.meaRate;
    binSize = params.psth.tBin * params.meaRate;
    nTBins = round(nSteps / binSize);
    
    [PSTH_neurons, ~, ~] = doPSTH(SpikeTimes, rep_begin_time_20khz, binSize, nTBins, params.meaRate, 1:numel(SpikeTimes));
    [chunkPSTH_neurons, ~] = extractEulerChunks(PSTH_neurons, 1/params.psth.tBin, euler, euler_sampler_rate);
    
    %----- STA ---------------------------------------%
    [temporal, spatial, indices_STA] = decomposeSTA(STAs);
    
    ellipseAreas = zeros(numel(spatial), 1);
    for iS = 1:numel(spatial)
        ellipseAreas(iS,:) = area(spatial(iS));
    end
    
    %----- VALID CELLS SELECTION ---------------------------%
    indices_tags = find(Tags>=acceptedLabels).';
    indices_neurons = getValidIndicesPSTH(chunkPSTH_neurons);
    indices_models = indices_Giulio_by_experiment{i_exp};

    indices_1 = intersect(indices, indices_tags);
    indices_2 = intersect(indices_1, indices_neurons);
    final_indices = intersect(indices_2, indices_models);  
    indices_list{i_exp} = final_indices;
    
    %----- DEFINE FEATURES ---------------------------%
    norm_areas = ellipseAreas(final_indices) / max(ellipseAreas(final_indices));

    norm_tsta_baseline = temporal(final_indices, 1:6);
    norm_tsta = temporal(final_indices, 7:21);
    norm_tsta = norm_tsta - mean(norm_tsta_baseline, 2);
    norm_tsta = norm_tsta ./ std(norm_tsta, [], 2);
    
    models_inv_indices = ismember(indices_models, final_indices);
    norm_psth_models = PSTH_models(models_inv_indices, :) ./ max(PSTH_models(models_inv_indices, :), [], 2);
    norm_psth_neurons = chunkPSTH_neurons(final_indices, :) ./ max(chunkPSTH_neurons(final_indices, :), [], 2);
    
    temporalSTAs = [temporalSTAs; norm_tsta];
    spatialSTAs = [spatialSTAs, spatial(final_indices)];
    stas = [stas, STAs(final_indices)];

    psths_neurons = [psths_neurons;  chunkPSTH_neurons(final_indices, :)];
    psths_models = [psths_models;  PSTH_models(models_inv_indices, :)];

    features_list{i_exp} = [norm_tsta, norm_areas];
    disp('')
end

createDataset(dataset_label, experiments, indices_list, features_list);
psths = psths_neurons;
save(getDatasetMat(), 'experiments', 'temporalSTAs', 'spatialSTAs', 'stas', 'psths', 'params', '-append')
load(getDatasetMat(), "cellsTable");
labels_neurons = containers.Map;
labels_neurons(char(dataset_label)) = logical(1:numel(cellsTable));
treeClassification(c_params_STA, labels_neurons);