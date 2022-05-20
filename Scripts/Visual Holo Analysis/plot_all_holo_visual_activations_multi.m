% clear
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
dh_section_id = 7;
visual_section_id = 4;
visual_win = [0.175 0.500];
activation_win = [0.250 0.601];

% exp_id = '20210721_grid';
% dh_section_id = 4;
% visual_section_id = 3;
% visual_win = [0.175 0.500];
% activation_win = [0.250 0.601];

n_spots = 2;
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

good_on_cells = intersect(on_cells, good_cells);
good_off_cells = intersect(off_cells, good_cells);
good_onoff_cells = intersect(onoff_cells, good_cells);

% Find Patterns and distances
patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Set_Types", set_types, ...
    "Allowed_N_Spots", n_spots, ...
    "Intensity_Spots", intensity_spots, ...
    "N_Min_Repetitions", min_number_reps);
        
try
    load(strcat('/home/fran_tr/Projects/MEA-Analysis/Scripts/Visual Holo Analysis/', exp_id, '.mat'));
catch
    [scores, ~, ~, ~] = compareHoloVisualActivations(exp_id, visual_section_id, dh_section_id, ...
        "Pattern_Idx", patterns, ...
        "Visual_Window", visual_win, ...
        "Activation_Window", activation_win, ...
        "Visual_Pattern_Id", visual_pattern_id);
    
    [non_linear_sum, activations, visual, holo] = nonLinearSumHoloVisual(exp_id, visual_section_id, dh_section_id, ...
        "Pattern_Idx", patterns, ...
        "Visual_Window", visual_win, ...
        "Activation_Window", activation_win, ...
        "Visual_Pattern_Id", visual_pattern_id);
    
    distances = getCell2DMDStimDistances(exp_id, dh_section_id, 'Normalize', true);

    save(strcat('/home/fran_tr/Projects/MEA-Analysis/Scripts/Visual Holo Analysis/', exp_id, '.mat'), 'scores', 'non_linear_sum', 'activations', 'visual', 'holo', 'distances');
end

surround_cells = find(distances > 1);
selected_cells = intersect(surround_cells, good_off_cells);

activation_scores = scores .* (activations.zs > 0);
activated_patterns2selectedcells = activation_scores(patterns, selected_cells) > min_score_for_plot;

activated_selectedcells = find(any(activated_patterns2selectedcells));
selected_cells_activated =  selected_cells(activated_selectedcells);

fprintf('showing %i cells:\n', numel(selected_cells_activated));

figure();
nl_sum_to_good = non_linear_sum(patterns, selected_cells);
nl_sum_to_surround_activated = nl_sum_to_good(activated_patterns2selectedcells);
nl_sum_for_histo = nl_sum_to_surround_activated(~isnan(nl_sum_to_surround_activated));

histogram(nl_sum_to_surround_activated, 20);
title('Non-linear score for pattern-cells pairs activated in the surround');
xlabel('MultiSpot Activation - Linear-Sum Activation (Hz)');
ylabel('Number Of Cells');
pause(2);

% cell 22 patterns 74
for cell_id = selected_cells_activated(:)'
    
        plotHoloSTAMultiSpot(exp_id, cell_id, dh_section_id, ...
            "Pattern_Idx", patterns, ...
            'Max_Firing_rate', max_fr_plot, ...
            'Show_MEA', true, ...
            'Weights', scores(patterns, cell_id), ...
            'Show_Stimulus', true);
        pause(3);
    
        [~, pattern_to_show_idx] = min(non_linear_sum(patterns, cell_id));
        pattern_to_show = patterns(pattern_to_show_idx);
        
        plotVisualHoloCardMultiSpot(exp_id, cell_id, dh_section_id, visual_section_id, ...
            "Holo_Pattern_Id_Multi", pattern_to_show, ...
            "Holo_Pattern_Idx_Single", holo.single_spot_patterns{pattern_to_show}, ...
            "Visual_Win", visual_win);
        title(strcat('showing activations for pattern #', num2str(pattern_to_show)));
    
        pause(3);
        plotHoloVisualActivation(cell_id, patterns, activations, visual, holo);
    
    pause(3);
    close all;
end

