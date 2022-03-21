function plotVisualHoloSynchronization(visual_vec, visual_triggers, dh_triggers, dh_durations, vec_channel)

visual_y = 5;
dh_y = 5;

visual_sequence = visual_vec(2:end, vec_channel);
visual_labels = unique(visual_sequence);

visual_sequence = visual_sequence(1:min(numel(visual_sequence), numel(visual_triggers)));
visual_triggers = visual_triggers(1:min(numel(visual_sequence), numel(visual_triggers)));

colors = getColors(numel(visual_labels) + 1);

figure();
ylim([4, 6])
xlim([dh_triggers(1), dh_triggers(min(numel(dh_triggers), 5))]);
hold on;

x_dh = [dh_triggers(:), dh_triggers(:) + dh_durations(:)]';
y_dh = ones(size(x_dh)) * dh_y;
legend_entries = plot(x_dh , y_dh, 'LineWidth', 5, 'Color', colors(1, :), 'DisplayName', 'Holography');
legend_entries = legend_entries(1);

for i_label = 1:numel(visual_labels)
    label = visual_labels(i_label);
    label_triggers = visual_triggers(visual_sequence == label);
    legend_entry = strcat("Visual (vec code ", num2str(label), ")");
    legend_entries(i_label + 1) = scatter(label_triggers, ones(1, numel(label_triggers)) * visual_y, 20, colors(i_label + 1, :), 'Filled', 'DisplayName', legend_entry);
    
end
ylim([4, 6])
xlim([dh_triggers(1), dh_triggers(min(numel(dh_triggers), 5))]);
legend(legend_entries);