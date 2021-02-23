clear

% dataset parameters
changeDataset('20200131_dh')
session_label = 'DHMulti20';    % label of the dataset that will be generated
reps_label = 'DHMulti';         % label of the session from which to get the repetitions
trigger_suffix = '_begin_time';     % '_begin_time' or '_end_time'

dissipation_func = @getDHFrameIntensities;
datasets = {'zero', 'single', 'multi', 'test'};

% PSTH parameters
dh_dataset.params.dissip_func = dissipation_func;
dh_dataset.params.reps_label = reps_label;
dh_dataset.params.t_label = trigger_suffix;

dh_dataset.params.stim_dt = 0.5;            % s
dh_dataset.params.response_init = -0.25;     % s
dh_dataset.params.response_dt = 1;        % s
dh_dataset.params.response_tbin = 0.05;    % s

% Load Data
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');

expId = getExpId();
n_cells = numel(spikes);
n_bins = floor(dh_dataset.params.response_dt / dh_dataset.params.response_tbin);
bin_size = dh_dataset.params.response_tbin * params.meaRate;

repetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions' reps_label '.mat'];
load(repetitionsFile, 'dh_sessions');

coordsFile = [dataPath() '/' expId '/processed/DH/DHCoords' reps_label '.mat'];
load(coordsFile, 'PatternCoords_MEA');
load(coordsFile, 'PatternCoords_Laser');
load(coordsFile, 'PatternCoords_Img');

% save spots
dh_dataset.spots.coords_mea =  PatternCoords_MEA;
dh_dataset.spots.coords_laser =  PatternCoords_Laser;
dh_dataset.spots.coords_img =  PatternCoords_Img;
dh_dataset.sessions = dh_sessions;
data.(session_label) = dh_dataset;
save(getDatasetMat, '-struct', 'data', "-append")

% save repetitions
for i_data = 1:numel(datasets)
    
    dataset_label = datasets{i_data};
    frames_label = [dataset_label '_frames'];
    trigger_label = [dataset_label trigger_suffix];

    % Get Repetitions
    reps = load(repetitionsFile, trigger_label);
    repetitions = reps.(trigger_label);
    n_patterns = numel(repetitions);

    s = load(repetitionsFile, frames_label);
    rep_frames = s.(frames_label);

    % Compute input intensities
    dh_dataset.stimuli.(dataset_label) = dissipation_func(dh_dataset, rep_frames);
    dh_dataset.repetitions.(dataset_label) = repetitions';

    % Compute all the responses for each pattern
    dh_dataset.responses.(dataset_label).firingRates = zeros(n_cells, n_patterns, n_bins);
    dh_dataset.responses.(dataset_label).spikeCounts = cell(n_cells, n_patterns);
    
    for i_p = 1:n_patterns
        % Responses to DH stim
        r_times = repetitions{i_p} + dh_dataset.params.response_init * params.meaRate;

        if ~isempty(r_times)
            [psth, ~, ~, responses] = doPSTH(spikes, r_times, bin_size, n_bins, params.meaRate, 1:n_cells);
            dh_dataset.responses.(dataset_label).firingRates(:, i_p, :) = psth;
            for i_cell = 1:n_cells
                dh_dataset.responses.(dataset_label).spikeCounts(i_cell, i_p) = {responses(i_cell, :, :)};
            end
        end
    end
end

dh_dataset.sessions = dh_sessions;
data.(session_label) = dh_dataset;
save(getDatasetMat, '-struct', 'data', "-append")

% computeDHActivation(session_label, 'single')
% computeDHActivation(session_label, 'test')

