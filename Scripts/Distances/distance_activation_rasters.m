clear
% close all

% Params
exp_id = '20210721_grid';
dh_section = 3;
n_spots = 1;
set_types = ["test"];
distance_normalized_by_radius = true;

% Fetch stuff
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_section);
scores = multi_psth.activations.scores;
activations = multi_psth.activations.zs;

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


figure();
for i_set = 1:numel(sets)
    
    set = sets{i_set};
    label = set_labels(i_set);
    color = set_colors(i_set, :);
    
    % Sort and format stuff
    my_scores = scores(patterns, set);
    my_distances_cells = distances_cells(set, patterns)';
    my_distances_spots = distances_spots(patterns)';
    my_cell_radii = radius(set);
    
    my_distances_spots = repmat(my_distances_spots, [1, numel(set)]);
    my_cell_radii = repmat(my_cell_radii', [numel(patterns), 1]);
    
    my_scores = my_scores(:)';
    my_distances_cells = my_distances_cells(:)';
    my_distances_spots = my_distances_spots(:)';
    my_cell_radii = my_cell_radii(:)';
    
    true_activations = my_scores ~= 0;
    my_scores = my_scores(true_activations);
    my_distances_cells = my_distances_cells(true_activations);
    my_distances_spots = my_distances_spots(true_activations);
    my_cell_radii = my_cell_radii(true_activations);
    
    % Plot
    subplot(numel(sets), 1, i_set);
    hold on
    scatter(my_distances_cells, my_scores, 10, color, 'Filled',  'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0);
    yline(0, 'k--');
    numel(my_distances_cells)
    title(label)
    if distance_normalized_by_radius
        xlabel('Normalize Distance');
%         xlim([0, 6])
    else
        xlabel('Distance (\mum)');
%         xlim([0, 500])
    end
    ylabel('Delta Firing Rate (Hz)');
%     ylim([-20, 20]);
end