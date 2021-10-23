n_spots = 1;
set_types = "test";

exp_id = '20200131_rbc';
dh_section = 3;



psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_section);

distances_spots = getPatternDistances(exp_id, dh_section);
distances_cells = getCell2PatternDistances(exp_id, dh_section)';

patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section), "Set_Types", set_types, "Allowed_N_Spots", n_spots);

scores = multi_psth.activations.scores;
activations = multi_psth.activations.zs;

[~, ~, ~, valid_cells] = getSTAsComponents(exp_id);


my_scores = scores(patterns, valid_cells);
my_distances_cells = distances_cells(patterns, valid_cells);
my_distances_spots = distances_spots(patterns)';

my_distances_spots = repmat(my_distances_spots, [1, numel(valid_cells)]);

my_scores = my_scores(:)';
my_distances_cells = my_distances_cells(:)';
my_distances_spots = my_distances_spots(:)';

true_activations = my_scores > 0;
my_scores = my_scores(true_activations);
my_distances_cells = my_distances_cells(true_activations);
my_distances_spots = my_distances_spots(true_activations);

[ ~, sorted_activations] = sort(my_scores);
my_scores = my_scores(sorted_activations);
my_distances_cells = my_distances_cells(sorted_activations);
my_distances_spots = my_distances_spots(sorted_activations);


scatter(my_distances_cells, my_scores, 50, 'r', 'Filled',  'MarkerFaceAlpha',1,'MarkerEdgeAlpha',0)
% colormap(jet(round(max(my_distances_spots))))


