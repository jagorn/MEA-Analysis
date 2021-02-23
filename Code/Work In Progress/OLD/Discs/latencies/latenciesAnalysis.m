clear
close all
loadDataset


% ON vs OFF
on_idx = find(abs(max(temporalSTAs, [], 2)) > abs(min(temporalSTAs, [], 2)));
off_idx = find(abs(max(temporalSTAs, [], 2)) < abs(min(temporalSTAs, [], 2)));

% params
discs_idx = 1:numel(discs_reps);
bin_edges = 0:discs.params.time_bin:.5;

figure()
fullScreen();
subplot(2,2,1)
[activation_times, activation_overlaps, ~] = getDiscLatencies(discs, on_idx, discs_idx, 'g2w', -inf, 0.05);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_overlaps)
ylabel('Activation Overlap (percentage of rfc)')

title('ON Center, background to white')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,2)
[activation_times, activation_overlaps, ~] = getDiscLatencies(discs, on_idx, discs_idx, 'b2w', -inf, 0.05);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_overlaps)
ylabel('Activation Overlap (percentage of rfc)')

title('ON Center, black to white')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,3)
[activation_times, ~, activation_distances] = getDiscLatencies(discs, on_idx, discs_idx, 'w2g', 20, -inf);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_distances)
ylabel('Distance from disc (microns)')
title('ON Surround, white to background')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,4)
[activation_times, ~, activation_distances] = getDiscLatencies(discs, on_idx, discs_idx, 'w2b', 20, -inf);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_distances)
ylabel('Distance from disc (microns)')
title('ON Surround, white to black')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])


figure()
fullScreen();
subplot(2,2,1)
[activation_times, activation_overlaps, ~] = getDiscLatencies(discs, off_idx, discs_idx, 'w2g', -inf, 0.05);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_overlaps)
ylabel('Activation Overlap (percentage of rfc)')

title('OFF Center, white to background')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,2)
[activation_times, activation_overlaps, ~] = getDiscLatencies(discs, off_idx, discs_idx, 'w2b', -inf, 0.05);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_overlaps)
ylabel('Activation Overlap (percentage of rfc)')

title('OFF Center, white to black')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,3)
[activation_times, ~, activation_distances] = getDiscLatencies(discs, off_idx, discs_idx, 'g2w', 20, -inf);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_distances)
ylabel('Distance from disc (microns)')
title('OFF Surround, background to white')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])

subplot(2,2,4)
[activation_times, ~, activation_distances] = getDiscLatencies(discs, off_idx, discs_idx, 'b2w', 20, -inf);
yyaxis left
histogram(activation_times, bin_edges, 'Normalization', 'Probability');
hold on 

yyaxis right
scatter(activation_times, activation_distances)
ylabel('Distance from disc (microns)')
title('OFF Surround, black to white')
xticks(bin_edges);
xlabel('Activation Time (seconds)');
xlim([0 0.5])





















































