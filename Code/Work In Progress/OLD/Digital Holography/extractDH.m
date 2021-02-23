% Extract all the info about the different DH sessions,
% Pool the repetitions and combine them in an unique set of triggers.

% PARAMS
exp_id = '20200109_a2';
dh_sessions = 1;
dh_reps_label = 'DH';
combine_as = 'STACK';  % CONCAT or STACK

if strcmp(combine_as, 'CONCAT')
    combine_patterns = @concatPatterns;
    combine_coords = @concatSpots;
elseif strcmp(combine_as, 'STACK')
    combine_patterns = @stackPatterns;
    combine_coords = @checkEqualsSpots;
else
    error('combine function not recognized: it must be CONCAT or STACK')
end

% paths
raw_file_path = [dataPath() '/' exp_id '/sorted/CONVERTED-NO-FILT.raw'];
dh_folder = [dataPath() '/' exp_id '/processed/DH'];

data_file = 'DHChannel_data.mat';
triggers_file = 'DHTimes.mat';
repetitions_file = ['DHRepetitions' dh_reps_label '.mat'];
coords_file = ['DHCoords' dh_reps_label '.mat'];

% Stim Triggers
% try
%     load([dh_folder '/' triggers_file], 'dhTimes')
%     fprintf("DHtTimes Loaded\n\n")
% catch
    try
        load([dh_folder '/' data_file], 'DHChannel_data')
    catch
        DHChannel_data = extractDataDH(raw_file_path);
        save([tmpPath '/' data_file], 'DHChannel_data', '-v7.3');
        movefile([tmpPath '/' data_file], dh_folder);
    end
    dhTimes = extractDHTriggers(DHChannel_data);
    save([tmpPath '/' triggers_file], 'dhTimes')
    movefile([tmpPath '/' triggers_file], dh_folder);
% end

% Repetitions
% 
% get the repetition (in time steps) of the DH stimuli.
% singleSpot_reps: repetition of single-spot patterns
% multiSpots_reps: repetition of repeated multi-spot patterns
% multiSpots_uniques: times of non-repeated multi-spot patterns

all_0_reps = cell(numel(dh_sessions), 1);
all_1_reps = cell(numel(dh_sessions), 1);
all_N_reps = cell(numel(dh_sessions), 1);
all_T_reps = cell(numel(dh_sessions), 1);
all_full_reps = cell(numel(dh_sessions), 1);

coords_dmd = cell(numel(dh_sessions), 1);
coords_2ph = cell(numel(dh_sessions), 1);
coords_mea = cell(numel(dh_sessions), 1);

for i_n = 1:numel(dh_sessions)
    i_dht = dh_sessions(i_n);
    
%     try
        % get the repetitions from different fields of view
        fprintf('Triggers set #%i:\n', i_dht);
        frames_file = [dh_folder '/DHFrames_' num2str(i_dht) '.mat'];
     
        [reps_0, reps_1, reps_N, reps_T, reps_full] = getDHSpotsRepetitions(dhTimes{i_dht}.evtTimes_begin, ...
                                                                    dhTimes{i_dht}.evtTimes_end, ...
                                                                    frames_file);
        all_0_reps{i_n} = reps_0;
        all_1_reps{i_n} = reps_1;
        all_N_reps{i_n} = reps_N;
        all_T_reps{i_n} = reps_T;
        all_full_reps{i_n} = reps_full;
                
        % Points in 2-Photons coords are used to compute the light intensities
        % Points in MEA coords are used to get their relative positions
        load(frames_file, "PatternMicron", "PatternImage");
        h_img2mea = getHomography(['img' num2str(i_dht)], 'mea', exp_id);
        coords_2ph{i_n} = PatternMicron;
        coords_dmd{i_n} = PatternImage;
        coords_mea{i_n} = transformPointsV(h_img2mea, PatternImage);

        fprintf('\tDH repetitions generated\n\n');
%     catch e
%         fprintf('\tnot possible to generate the DH repetitions:\n');
%         fprintf('\t%s: %s\n', e.identifier, e.message);
%     end
end

% combine patterns
[zero_frames, zero_begin_time, zero_end_time]       = combine_patterns(all_0_reps);
[single_frames, single_begin_time, single_end_time] = combine_patterns(all_1_reps);
[multi_frames, multi_begin_time, multi_end_time]    = combine_patterns(all_N_reps);
[test_frames, test_begin_time, test_end_time]       = combine_patterns(all_T_reps);
[all_frames, all_begin_time, all_end_time]       = combine_patterns(all_full_reps);

% combine spot coords
PatternCoords_Img = combine_coords(coords_dmd);
PatternCoords_Laser = combine_coords(coords_2ph);
PatternCoords_MEA = combine_coords(coords_mea);

% Save the repetitions
save([tmpPath(), '/' repetitions_file], "zero_begin_time", "zero_end_time", "zero_frames");
save([tmpPath(), '/' repetitions_file], "single_begin_time", "single_end_time", "single_frames", "-append");
save([tmpPath(), '/' repetitions_file], "multi_begin_time", "multi_end_time", "multi_frames", "-append");
save([tmpPath(), '/' repetitions_file], "test_begin_time", "test_end_time", "test_frames", "-append");
save([tmpPath(), '/' repetitions_file], "all_begin_time", "all_end_time", "all_frames", "-append");
save([tmpPath(), '/' repetitions_file], "dh_sessions", "-append");
save([tmpPath(), '/' coords_file], "PatternCoords_Laser", "PatternCoords_Img");
save([tmpPath(), '/' coords_file], "PatternCoords_MEA", "-append");

movefile([tmpPath(), '/' repetitions_file], dh_folder);
movefile([tmpPath(), '/' coords_file], dh_folder);
