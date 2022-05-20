close all

visual_section = 3;
holo_section = 3;
holo_visual_section = 4;
exp_id = '20210517_a2';
dataset_id = '20210517_gtacr';

changeDataset(dataset_id);

visual_minus_holo_score = compareHoloVisualActivations_OLD();
distance_matrix = getCell2PatternDistances_OLD(exp_id, holo_visual_section);

psths = getHolographyPSTHs(exp_id);
only_holo_psth = psths(holo_section);

only_holo_scores = only_holo_psth.activations.scores;
only_holo_scores(only_holo_scores < 0) = 0;

good_cells = find(sum(only_holo_psth.activations.zs) > 0);
n_cells = size(only_holo_psth.activations.zs, 2);

[temporal, ~, rfs, valid_cells] = getSTAsComponents(exp_id);
polarities = getPolarity(temporal);
off_cells = find(strcmp(polarities, 'OFF'));

good_cells_with_sta = intersect(good_cells, valid_cells);
valid_offs = intersect(valid_cells, off_cells);

percentage_good_cells_from_sta = numel(good_cells_with_sta) / numel(valid_cells) * 100
percentage_good_cells_from_activated = numel(good_cells_with_sta) / numel(good_cells) * 100
percentage_good_cells = numel(good_cells) / n_cells

figure()

scores = [];
distances = [];
for i_cell = valid_offs(:)'
    rf = rfs(i_cell);
    scores = [scores visual_minus_holo_score(i_cell, :)];
    distances = [distances distance_matrix(i_cell, :)];
end
[averages, stds, vinterval]  = histwc(distances, scores, 20, 100, 500);
bar(vinterval, averages)
hold on
errorbar(vinterval, averages, stds)
xlabel('distance (microns)');
ylabel('firing rate difference (Visual - Visual/Inhibition');



figure();
act_distances = distance_matrix(logical(only_holo_psth.activations.zs));
act_distances = act_distances(~isnan(act_distances));
histogram(act_distances, [0:100:1200])
ylim([0, 4])
xlabel('distance (microns)');
ylabel('number of activations recorded');

