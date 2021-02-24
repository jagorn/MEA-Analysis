function plotPsthMEA(psths, period, mea_positions, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'psths');
addRequired(p, 'period');
addRequired(p, 'mea_positions');
addParameter(p, 'Offset', 0);
addParameter(p, 'Colors', []);

parse(p, psths, period, mea_positions, varargin{:});
offset = p.Results.Offset;
colors = p.Results.Colors;

[n_elecs, n_steps] = size(psths);
max_psth = max(psths(:));

if isempty(colors)
    colors = zeros(n_elecs, 3);
end


hold on
for i_elec = 1:n_elecs
        
    x_norm = (1/n_steps : 1/n_steps : 1) - 0.5/n_steps;
    y_norm = squeeze(psths(i_elec, :) / max_psth);
    
    x_pos = mea_positions(i_elec, 1) - 0.5;
    y_pos = mea_positions(i_elec, 2) - 0.5;
    
    x_plot = x_norm + x_pos;
    y_plot = y_norm + y_pos;
        
    base = ones(size(y_plot)) * y_pos;
    x_between = [x_plot, fliplr(x_plot)];
    in_between = [y_plot, fliplr(base)];
    fill(x_between(:), in_between(:), colors(i_elec, :), 'EdgeColor', colors(i_elec, :));
        
    if offset ~= 0
        onset_plot = x_pos + offset/period;
        offset_plot = x_pos + (period - offset)/period;

        plot([onset_plot, onset_plot], [y_pos, y_pos + 1], 'g--', 'LineWidth', 1);
        plot([offset_plot, offset_plot], [y_pos, y_pos + 1], 'r--', 'LineWidth', 1);
    end
end

