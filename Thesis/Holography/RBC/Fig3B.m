clear
close all

% Params
exp_id = '20191011_grid_no_thresh';
dh_section = 3;
n_spots = 1;
set_types = ["test"];
distance_normalized_by_radius = false;

% Fetch stuff
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_section);
scores = multi_psth.activations.scores;
baselines = multi_psth.activations.baselines;

% Select Valid Cells
[center, radius, vertices, surface, valid_stas] = getMEASTAs(exp_id);
tags = getTags(exp_id);
tagged_cells = find(tags>=3);
best_cells = intersect(valid_stas(:)', tagged_cells(:)');

% Find ON vs OFF cells
[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
[polarities, on_cells, off_cells, none_cells] = getPolarity(temporal);


% Compute distances
if distance_normalized_by_radius
    distances_cells = getCell2PatternShortestNormDistance(exp_id, dh_section);
else
    distances_cells = getCell2PatternShortestDistances(exp_id, dh_section);
end
distances_spots = getPatternShortestDistances(exp_id, dh_section);

% Select patterns
patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section), ...
    "Set_Types", set_types, ...
    "Allowed_N_Spots", n_spots);

best_on_cells = intersect(on_cells, best_cells);
best_off_cells = intersect(off_cells, best_cells);
best_none_cells = intersect(none_cells, best_cells);

sets = {best_on_cells, best_off_cells};
set_labels = ["ON RGCs", "OFF RGCs"];
set_colors = [0.99, 0.5, 0.5; 0.5, 0.5, 0.99];


f1 = figure();
for i_set = 1:numel(sets)
    
    set = sets{i_set};
    label = set_labels(i_set);
    color = set_colors(i_set, :);
    
    % Sort and format stuff
    my_scores = scores(patterns, set);
    my_baselines = baselines(patterns, set);
    my_distances_cells = distances_cells(set, patterns)';
    my_distances_spots = distances_spots(patterns)';
    my_cell_radii = radius(set);
    
    my_distances_spots = repmat(my_distances_spots, [1, numel(set)]);
    my_cell_radii = repmat(my_cell_radii', [numel(patterns), 1]);
    
    my_scores = my_scores(:)';
    my_baselines = my_baselines(:)';
    my_distances_cells = my_distances_cells(:)';
    my_distances_spots = my_distances_spots(:)';
    my_cell_radii = my_cell_radii(:)';
    
    true_activations = my_scores ~= 0;
    my_scores = my_scores(true_activations);
    my_baselines = my_baselines(true_activations);
    my_distances_cells = my_distances_cells(true_activations);
    my_distances_spots = my_distances_spots(true_activations);
    my_cell_radii = my_cell_radii(true_activations);
    
    % Plot
    figure(f1);
    subplot(numel(sets), 1, i_set);
    hold on
    
    [colors, color_map] = value2HeatColor(round(my_distances_cells), 0, 500, false);
    scatter(my_baselines, my_scores + my_baselines, 20, colors, 'Filled',  'MarkerEdgeColor', 'k', 'MarkerFaceAlpha', 1,'MarkerEdgeAlpha',1);
    plot([0, 15], [0, 15], 'k--');
    yline(0, 'k--');
    numel(my_distances_cells)
    title(label)

    ylabel('Response Firing Rate (Hz)');
    xlabel('Spontaneous Firing Rate (Hz)');
    ylim([0 20]);
end

plotColorBar(color_map, 0, 500, "distance");
