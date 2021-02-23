function plotDiscsPsths(i_cell, discs, disc_idx, colors, labels)

row_min = min(0, discs.tresh_down(i_cell));
row_max = max(max(max(discs.psths(i_cell, :, :))), discs.tresh_up(i_cell));

row_tickness = row_max-row_min;
basevalue = -row_min;
hold on;

% Do background
background_rect = [discs.dt_background0(1), 0, discs.dt_background4(2) - discs.dt_background0(1), row_tickness*numel(disc_idx)];
rectangle('Position', background_rect, 'FaceColor', [.5 .5 .5 .5], 'EdgeColor', 'none')

white_rect = [discs.dt_white1(1), 0, discs.dt_white3(2) - discs.dt_white1(1), row_tickness*numel(disc_idx)];
rectangle('Position', white_rect, 'FaceColor', [1 1 1 .5], 'EdgeColor', 'none')

black_rect = [discs.dt_black2(1), 0, discs.dt_black2(2) - discs.dt_black2(1), row_tickness*numel(disc_idx)];
rectangle('Position', black_rect, 'FaceColor', [0 0 0 .5], 'EdgeColor', 'none')  

% Do PSTHs
for i_disc = disc_idx
    trace = squeeze(discs.psths(i_cell, i_disc, :)) + basevalue; 
    color = colors(i_disc, :);
    
    base = ones(size(trace)) * basevalue;
    x_between = [discs.t_psths, fliplr(discs.t_psths)];
    in_between = [trace; fliplr(base)];
    fill(x_between(:), in_between(:), color, 'EdgeColor', color);
    
    
    yline(discs.tresh_up(i_cell) + basevalue, 'r:');
    yline(discs.avg_base(i_cell) + basevalue, 'k:');
    yline(discs.tresh_down(i_cell) + basevalue, 'b:');
    
    for t = discs.activations{i_cell, i_disc}
        scatter(t, discs.tresh_up(i_cell) + basevalue, 'r+');
    end

    for t = discs.suppressions{i_cell, i_disc}
        scatter(t, discs.tresh_down(i_cell) + basevalue, 'b+');
    end
    basevalue = basevalue + row_tickness;
end


yticks(0:row_tickness:(row_tickness*numel(disc_idx)))
yticklabels(labels)
ylim([0 row_tickness*numel(disc_idx)])
xlabel('time (Hz)')
