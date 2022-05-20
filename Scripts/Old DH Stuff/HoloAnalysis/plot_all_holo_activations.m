clear
close all

% Params
max_fr_plot = 30;

exp_id = '20200131_rbc';
dh_section_id = 3;

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

good_on_cells = intersect(on_cells, good_cells);
good_off_cells = intersect(off_cells, good_cells);
good_onoff_cells = intersect(onoff_cells, good_cells);


% Chose Patterns and compute distances
patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Set_Types", set_types, ...
    "Allowed_N_Spots", n_spots, ...
    "Intensity_Spots", intensity_spots, ...
    "N_Min_Repetitions", min_number_reps);

distances = getCell2PatternShortestNormDistance(exp_id, dh_section_id);

% Get Activations
[activations, holo] = getHoloActivations(exp_id, dh_section_id);

activated_patterns2cells = activations.zs(patterns, :) > 0;
surround_patterns2cells = distances(:, patterns)' > 1;
activated_surround_patterns2cells = activated_patterns2cells & surround_patterns2cells;

activated_surround_cells = find(any(activated_surround_patterns2cells));
cells_to_show = intersect(activated_surround_cells, good_cells);

fprintf('showing %i cells.', numel(cells_to_show));
for cell_id = cells_to_show(:)'
    patterns_to_show = patterns(surround_patterns2cells(:, cell_id));
    
    plotHoloSTA(exp_id, cell_id, dh_section_id, ...
        "Pattern_Idx", patterns_to_show, ...
        'Max_Firing_rate', max_fr_plot, ...
        'Show_MEA', true, ...
        'Weights', activations.scores(patterns_to_show, cell_id));
    pause(3);
   
    [max_activation, max_pattern_idx] = max(activations.scores(patterns_to_show, cell_id));
    max_pattern = patterns_to_show(max_pattern_idx);
    
    plotFluoCard(exp_id, dh_section_id, cell_id, max_pattern);
    suptitle(strcat("Cell #", num2str(cell_id), " Pattern #", num2str(max_pattern)));
    pause(3);
    plotHoloActivation(cell_id, patterns, activations, holo);
    
    pause(3);  
    close all;
end

