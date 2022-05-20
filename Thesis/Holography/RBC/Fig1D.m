clear
close all

% Params
experiments = {'20200131_rbc'};
dh_sections = {3};
n_spots = 1;
intensity_spots = 1;
set_types = "test";
distance_normalized_by_radius = true;

max_distance = 500;
max_normalized_distance = 5;
n_distance_bins = 15;

set_labels = ["ON RGCs", "OFF RGCs"];
set_colors = [0.99, 0.5, 0.5; 0.5, 0.5, 0.99];
    
scores_pulled = cell([1, 2]);
latencies_pulled = cell([1, 2]);
distances_cells_pulled = cell([1, 2]);
distances_spots_pulled = cell([1, 2]);
cell_radii_pulled = cell([1, 2]);
test_samples = cell(2, n_distance_bins);

if distance_normalized_by_radius
    max_d = max_normalized_distance;
else
    max_d = max_distance;
end
edges_d = linspace(0, max_d, n_distance_bins + 1);

for i_section = 1:numel(dh_sections)
    
    exp_id = experiments{i_section};
    dh_section = dh_sections{i_section};
    
    % Fetch stuff
    psths = getHolographyPSTHs(exp_id);
    multi_psth = psths(dh_section);
    scores = multi_psth.activations.scores;
    latencies = multi_psth.activations.latencies;
    
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
        "Allowed_N_Spots", n_spots, ...
        "Intensity_Spots", intensity_spots);
    
    best_on_cells = intersect(on_cells, best_cells);
    best_off_cells = intersect(off_cells, best_cells);
    best_none_cells = intersect(none_cells, best_cells);
    
    sets = {best_on_cells, best_off_cells};   
    
    for i_set = 1:2 
        set = sets{i_set};

        % Sort and format stuff
        my_scores = scores(patterns, set);
        my_latencies = latencies(patterns, set);
        my_distances_cells = distances_cells(set, patterns)';
        my_distances_spots = distances_spots(patterns)';
        my_cell_radii = radius(set);
        
        my_distances_spots = repmat(my_distances_spots, [1, numel(set)]);
        my_cell_radii = repmat(my_cell_radii', [numel(patterns), 1]);
        
        scores_pulled{i_set} = [scores_pulled{i_set} my_scores(:)'];
        latencies_pulled{i_set} = [latencies_pulled{i_set} my_latencies(:)'];
        distances_cells_pulled{i_set} = [distances_cells_pulled{i_set} my_distances_cells(:)'];
        distances_spots_pulled{i_set} = [distances_spots_pulled{i_set} my_distances_spots(:)'];
        cell_radii_pulled{i_set} = [cell_radii_pulled{i_set} my_cell_radii(:)'];
    end
end

for i_set = 1:2
            
    label = set_labels(i_set);
    color = set_colors(i_set, :);
        
    my_scores = scores_pulled{i_set};
    my_latencies = latencies_pulled{i_set};
    my_distances_cells = distances_cells_pulled{i_set};
    my_distances_spots = distances_spots_pulled{i_set};
    my_cell_radii = cell_radii_pulled{i_set};
    
    activations_histo = zeros(1, n_distance_bins);
    error_histo = zeros(1, n_distance_bins);
    
    fr_mean_histo = zeros(1, n_distance_bins);
    fr_std_histo = zeros(1, n_distance_bins);
    
    
    true_activations = my_scores > 0;
    my_scores_raster = my_scores(true_activations);
    my_latencies_raster = my_latencies(true_activations);
    my_distances_cells_raster = my_distances_cells(true_activations);
    my_distances_spots_raster = my_distances_spots(true_activations);
    my_cell_radii_raster = my_cell_radii(true_activations);
        
    for i_bin = 1:numel(activations_histo)
        left_edge = edges_d(i_bin);
        right_edge = edges_d(i_bin+1);
        
        bin_scores = my_scores((my_distances_cells >= left_edge) & (my_distances_cells < right_edge));
        n_pairs = numel(bin_scores);
        activations_bin = sum(bin_scores > 0) /n_pairs;
        error_bin = sqrt(n_pairs .* activations_bin .* (1 - activations_bin)) ./ n_pairs;
        
        fr_mean = mean(bin_scores(bin_scores > 0));
        fr_std = std(bin_scores(bin_scores > 0));
        
        activations_histo(i_bin) = activations_bin * 100;
        error_histo(i_bin) = error_bin * 100;
        
        fr_mean_histo(i_bin) = fr_mean;
        fr_std_histo(i_bin) = fr_std;
        
        test_samples{i_set, i_bin} = bin_scores > 0;
    end
    
    % Plot activation counts
    f1 = figure(1);
    subplot(numel(sets), 1, i_set);
    hold on
    area(edges_d, [0 activations_histo], 'FaceColor', color);
    errorbar(edges_d, [0 activations_histo], [0 error_histo], 'Color', 'k');
    
    title(label)
    if distance_normalized_by_radius
        xlabel('Normalize Distance (a.u.)');
    else
        xlabel('Distance (\mum)');
    end
    ylabel('Percentage of Activations (%)');
    ylim([0, 15]);
    
    % Plot firing rates
    f2 = figure(2);
    subplot(numel(sets), 1, i_set);
    hold on
    
    % Plot Standard Deviation
    fr_idx = ~isnan(fr_mean_histo);
    fr_mean_histo = fr_mean_histo(fr_idx);
    fr_std_histo = fr_std_histo(fr_idx);
    edges__fr_histo = edges_d(logical([1 fr_idx]));
    
    x2 = [edges__fr_histo, fliplr(edges__fr_histo)];
    inBetween = [[0 fr_mean_histo + fr_std_histo/2], fliplr([0 fr_mean_histo - fr_std_histo/2])];
    scatter(my_distances_cells_raster, my_scores_raster, 10, color, 'Filled',  'MarkerFaceAlpha', 1);
    fill(x2, inBetween, color, 'FaceAlpha', 0.5, 'EdgeAlpha', 0);
    plot(edges__fr_histo, [0 fr_mean_histo], 'Color', 'k', 'LineWidth', 1);
    
    xlim([0 5]);
    ylim([0 100]);
    
    title(label)
    if distance_normalized_by_radius
        xlabel('Normalize Distance (a.u.)');
    else
        xlabel('Distance (\mum)');
    end
    ylabel('Delta Firing Rate (Hz)');
    
    
    % Plot latencies
    f3 = figure(3);
    subplot(numel(sets), 1, i_set);
    hold on
    
    % Plot Standard Deviation
    scatter(my_distances_cells_raster, my_latencies_raster, 10, color, 'Filled',  'MarkerFaceAlpha', 1);
    
    title(label)
    if distance_normalized_by_radius
        xlabel('Normalize Distance (a.u.)');
    else
        xlabel('Distance (\mum)');
    end
    ylabel('Response Latency (s)');
    
    f4 = figure(4);
    subplot(1, numel(sets), i_set);
    histogram(my_latencies_raster(my_distances_cells_raster>1), 0:0.05:0.5, 'FaceColor', color);
    yticks([0 5 10 15 20 25])
    ylim([0, 25]);
    xlabel('Latency of Surround Responses (s)');
    ylabel('Number of Activated Cells');
    title(label);
end

ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);
f1.Position =  [0, (height/2 -300), width/2, 600];
f2.Position =  [width, (height/2 -300), width/2, 600];


% T-Test
fprintf('T-Test for ON vs OFF delta Firing Rate:\n');
for i_bin = 1:n_distance_bins
    samples_on = test_samples{1, i_bin};
    samples_off = test_samples{2, i_bin};
    
    activations_on = sum(samples_on);
    activations_off = sum(samples_off);
    
    silences_on = sum(~samples_on);
    silences_off = sum(~samples_off);
    
    fisher_table = table([activations_on;activations_off], [silences_on;silences_off], ...
                         'VariableNames', {'Response','NoResponse'}, ...
                         'RowNames', {'ON','OFF'});
                     
    [h, p_val] = fishertest(fisher_table, 'Alpha', 0.01);
    result_test_outcomes = ["FAILURE", "SUCCESS"];
    result_test = result_test_outcomes(h+1);
    fprintf('\tinterval <%f - %f> microns: %s. P value = %f\n', edges_d(i_bin), edges_d(i_bin + 1), result_test, p_val); 
end