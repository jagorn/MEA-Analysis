clear
close all

% Params
visual_pattern_id = 1;

min_score_for_plot = 10;
max_fr_plot = 30;

% exp_id = '20210517_a2';
% dh_section_id = 4;
% visual_section_id = 4;
% visual_win = [0.175 0.350];
% activation_win = [0.200 0.401];

exp_id = '20210804a_a2';
dh_section_id = 5;
visual_section_id = 3;
visual_win = [0.175 0.500];
activation_win = [0.250 0.601];

% exp_id = '20210721_grid';
% dh_section_id = 4;
% visual_section_id = 3;
% visual_win = [0.175 0.500];
% activation_win = [0.250 0.601];

n_spots = 1;
intensity_spots = 1;
set_types = ["train", "test"];
min_number_reps = 5;

% Select Valid Cells
[center, radius, vertices, surface, valid_stas] = getMEASTAs(exp_id);
tags = getTags(exp_id);
tagged_cells = find(tags>=3);
good_cells = intersect(valid_stas(:)', tagged_cells(:)');

% Find ON vs OFF cells
[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
[polarities, on_cells, off_cells, onoff_cells] = getPolarity(temporal);

patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Set_Types", set_types, ...
    "Allowed_N_Spots", n_spots, ...
    "Intensity_Spots", intensity_spots, ...
    "N_Min_Repetitions", min_number_reps);

good_on_cells = intersect(on_cells, good_cells);
good_off_cells = intersect(off_cells, good_cells);
good_onoff_cells = intersect(onoff_cells, good_cells);

[scores, activations, visual, holo] = compareHoloVisualActivations(exp_id, visual_section_id, dh_section_id, ...
    "Pattern_Idx", patterns, ...
    "Visual_Window", visual_win, ...
    "Activation_Window", activation_win, ...
    "Visual_Pattern_Id", visual_pattern_id);

activation_scores = scores .* (activations.zs > 0);
activated_cells = find(max(activation_scores) >= min_score_for_plot);
cells_to_show = intersect(activated_cells, good_off_cells);

fprintf('showing %i cells.', numel(cells_to_show));

for cell_id = cells_to_show(:)'
    
    plotHoloSTA(exp_id, cell_id, dh_section_id, ...
        "Pattern_Idx", patterns, ...
        'Max_Firing_rate', max_fr_plot, ...
        'Show_MEA', true, ...
        'Weights', scores(patterns, cell_id), ...
        'Show_Stimulus', true);
    pause(3);
   
    [max_activation, max_pattern] = max(activation_scores(:, cell_id));
    plotVisualHoloCard(exp_id, cell_id, dh_section_id, visual_section_id, ...
        "Holo_Pattern_Id", max_pattern, ...
        "Visual_Pattern_Id", visual_pattern_id, ...
        "Visual_Win", visual_win);
    
    
    pause(3);
    plotHoloVisualActivation(cell_id, patterns, activations, visual, holo);
    
    pause(3);  
    close all;
end

