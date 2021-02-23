clear

% parameters
expId = '20191011_grid';
dh_session = 6;
spot_attenuation_func = @getDHFrameIntensities;
mea_rate = 20000;

% Load Data
repetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions_' num2str(dh_session) '.mat'];
spikesFile = [dataPath() '/' expId '/processed/muaSpikeTimes.mat'];
load(spikesFile, 'spike_times_dt');
spikes = spike_times_dt;
n_cells = numel(spikes);

% PSTH parameters
dh.t_bin = 0.3; % s
dh.offset = 0.1; % s

bin_size = dh.t_bin * mea_rate;

% Iterate over the different types of stimulatione sequences
patterns_types = ["zero", "singles", "multi", "test"];
patterns_begin_time = ["zero_begin_time", "single_begin_time",  "multi_begin_time",  "test_begin_time"];
patterns_frames = ["zero_frames", "single_frames", "multi_frames", "test_frames"];

for i_patt = 1:numel(patterns_types)
    
    pattern_type = patterns_types(i_patt);
    repetitions = load(repetitionsFile, patterns_begin_time(i_patt));
    repetitions = repetitions.(patterns_begin_time(i_patt));
    
    rep_frames = load(repetitionsFile, patterns_frames(i_patt));
    rep_frames = rep_frames.(patterns_frames(i_patt));

    % Get Repetitions
    n_patterns = numel(repetitions);
    
    % Compute input intensities
    dh.stimuli.(pattern_type) = spot_attenuation_func(expId, rep_frames);

    % Compute all the responses for each pattern
    dh.responses.(pattern_type).firingRates = zeros(n_cells, n_patterns);
    dh.responses.(pattern_type).spikeCounts = cell(n_cells, n_patterns);
    
    for i_p = 1:n_patterns
        % Responses to DH stim
        r_times = repetitions{i_p};
        
        if ~isempty(r_times)
            [psth, ~, ~, responses] = doPSTH(spikes, r_times + dh.offset, bin_size, 1, mea_rate, 1:n_cells);
            dh.responses.(pattern_type).firingRates(:, i_p) = psth;
            for i_cell = 1:n_cells
                dh.responses.(pattern_type).spikeCounts(i_cell, i_p) = {responses(i_cell, :)};
            end
        end
    end
end

save([tmpPath '/' 'DH_' num2str(dh_session) '.mat'], "dh")
movefile([tmpPath '/' 'DH_' num2str(dh_session) '.mat'],  [dataPath() '/' expId '/processed/DH'])