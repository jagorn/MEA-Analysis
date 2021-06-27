function plotTimeWindowsMEA(time_windows, chunk_size, mea_map, varargin)

% Default Parameters
electrodes_def = 1:size(mea_map, 1);
color_def = [0.9 0.2 0.2 0.3];

% Parse Input
p = inputParser;
addRequired(p, 'time_windows');
addRequired(p, 'mea_map');
addParameter(p, 'Electrodes', electrodes_def);
addParameter(p, 'Color', color_def);

parse(p, time_windows, mea_map, varargin{:});

electrodes = p.Results.Electrodes;
color = p.Results.Color;

mea_size = size(mea_map, 1);
time_windows_norm = time_windows / chunk_size * 0.9 - 0.45;

for i_electrode = 1:mea_size
    if any(i_electrode == electrodes)
    
        x_mea = mea_map(i_electrode, 1);
        y_mea = mea_map(i_electrode, 2);

        for t = time_windows_norm'
            
            x_plot = x_mea + t(1);
            y_plot = y_mea - 0.5;

            dx = t(2) - t(1);
            dy = 1;

            rectangle('Position', [x_plot, y_plot, dx, dy], 'FaceColor', color, 'EdgeColor', 'None')
        end
    end
end
