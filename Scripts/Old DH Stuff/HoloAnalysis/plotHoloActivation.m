function plotHoloActivation(cell_id, patterns, activations, holo)

n_col = 5;
n_row = ceil(numel(patterns)/n_col);

max_y = max(max(max(holo.psth(patterns, cell_id, :))))* 1.05;

figure();
for i_pattern = 1:numel(patterns)
    pattern_id = patterns(i_pattern);
    holo_snippet_t = holo.t(holo.t > activations.win(1) & holo.t <= activations.win(2));
    holo_snippet = holo.psth(:, :, holo.t > activations.win(1) & holo.t <= activations.win(2));
    
    fullScreen();
    subplot(n_row, n_col, i_pattern);
    
    hold on
    h = plot(holo.t, squeeze(holo.psth(pattern_id, cell_id, :)), 'Color', 'k', 'LineWidth', 1);
    area(holo_snippet_t, squeeze(holo_snippet(pattern_id, cell_id, :)), 'FaceColor', 'k', 'EdgeAlpha', 0, 'FaceAlpha', 0.5)
    
    if isfield(holo, 'linear_sums')
        if all(~isnan(squeeze(holo.linear_sums(pattern_id, cell_id, :))))
            plot(holo_snippet_t, squeeze(holo.linear_sums(pattern_id, cell_id, :)), 'b', 'LineWidth', 1)
        end
    end
    
    xlabel('time (s)')
    ylabel('firing rate (hz)');
    xline(holo.win(1), 'k--');
    xline(holo.win(2), 'k--');
    ylim([0 max_y]);
    xlim([-0.2, 1.2])
    title(strcat('Cell #', num2str(cell_id), " pattern #", num2str(pattern_id)));
end

