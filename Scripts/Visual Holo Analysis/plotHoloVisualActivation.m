function plotHoloVisualActivation(cell_id, patterns, activations, visual, holo)

n_col = 5;
n_row = ceil(numel(patterns)/n_col);

max_visual = max(max(visual.psth(cell_id, :)));
max_holo = max(max(max(holo.psth(patterns, cell_id, :))));
max_y = 80; %max(max_holo, max_visual) * 1.05;

figure();
for i_pattern = 1:numel(patterns)
    pattern_id = patterns(i_pattern);
    visual_snippet_t = visual.t(visual.t > activations.win(1) & visual.t <= activations.win(2));
    visual_snippet = visual.psth(:, visual.t > activations.win(1) & visual.t <= activations.win(2));
    
    holo_snippet_t = holo.t(holo.t > activations.win(1) & holo.t <= activations.win(2));
    holo_snippet = holo.psth(:, :, holo.t > activations.win(1) & holo.t <= activations.win(2));
    
    fullScreen();
    subplot(n_row, n_col, i_pattern);
    
    hold on
    plot(visual.t, visual.psth(cell_id, :), 'Color', 'r', 'LineWidth', 1);
    area(visual_snippet_t, visual_snippet(cell_id, :), 'FaceColor', 'r', 'EdgeAlpha', 0, 'FaceAlpha', 0.5)
    h = plot(holo.t, squeeze(holo.psth(pattern_id, cell_id, :)), 'Color', 'k', 'LineWidth', 1);
    area(holo_snippet_t, squeeze(holo_snippet(pattern_id, cell_id, :)), 'FaceColor', 'k', 'EdgeAlpha', 0, 'FaceAlpha', 0.5)
    
    if isfield(holo, 'linear_sums')
        if all(~isnan(squeeze(holo.linear_sums(pattern_id, cell_id, :))))
            plot(holo_snippet_t, squeeze(holo.linear_sums(pattern_id, cell_id, :)), 'b--', 'LineWidth', 1)
        end
    end
    
    xlabel('time (s)')
    ylabel('firing rate (hz)');
    xline(holo.win(1), 'k--');
    xline(holo.win(2), 'k--');
    xline(visual.win(1), 'r--');
    xline(visual.win(2), 'r--');
    ylim([0 max_y]);
    xlim([-0.2, 1.2])
    title(strcat('Cell #', num2str(cell_id), " pattern #", num2str(pattern_id)));
end

