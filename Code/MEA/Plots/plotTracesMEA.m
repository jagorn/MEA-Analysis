function plotTracesMEA(traces, mea_map, varargin)


% Default Parameters
dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
color_def = 'k';
color_stim_def = 'b';
color_dead_def = 'r';


% Parse Input
p = inputParser;
addRequired(p, 'traces');
addRequired(p, 'mea_map');
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'Color', color_def);
addParameter(p, 'Color_Stim', color_stim_def);
addParameter(p, 'Color_Dead', color_dead_def);

parse(p, traces, mea_map, varargin{:});

dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
color = p.Results.Color;
color_stim = p.Results.Color_Stim;
color_dead = p.Results.Color_Dead;

volt_factor = 0.001;
[mea_size, chunk_size] = size(traces);

x_wave = linspace(-0.45, +0.45, chunk_size);

for i_electrode = 1:mea_size
    x_mea = mea_map(i_electrode, 1);
    y_mea = mea_map(i_electrode, 2);
    
    x_plot = x_wave + x_mea;
    y_plot = traces(i_electrode, :) * volt_factor + y_mea;
    
    if any(i_electrode == dead_electrodes)
        electrode_color = color_dead;
    elseif any(i_electrode == stim_electrodes)
        electrode_color = color_stim;
    else
        electrode_color = color;
    end
    plot(x_plot, y_plot, electrode_color);
end
