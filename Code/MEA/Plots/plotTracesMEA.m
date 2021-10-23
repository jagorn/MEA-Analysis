function plotTracesMEA(traces, mea_map, varargin)


% Default Parameters
dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
trace_scale_def = 1000;
stim_scale_def = 10000;
color_def = 'k';
color_stim_def = 'b';
color_dead_def = 'r';


% Parse Input
p = inputParser;
addRequired(p, 'traces');
addRequired(p, 'mea_map');
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'Trace_Scale_mv', trace_scale_def);
addParameter(p, 'Stim_Scale_mv', stim_scale_def);
addParameter(p, 'Color', color_def);
addParameter(p, 'Color_Stim', color_stim_def);
addParameter(p, 'Color_Dead', color_dead_def);

parse(p, traces, mea_map, varargin{:});

dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
trace_scale = p.Results.Trace_Scale_mv;
stim_scale = p.Results.Stim_Scale_mv;
color = p.Results.Color;
color_stim = p.Results.Color_Stim;
color_dead = p.Results.Color_Dead;

[mea_size, chunk_size] = size(traces);

x_wave = linspace(-0.45, +0.45, chunk_size);

for i_electrode = 1:mea_size
    if any(i_electrode == stim_electrodes)
        volt_factor = 1/stim_scale;
    else
        volt_factor = 1/trace_scale;
    end
    
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
    plot(x_plot, y_plot, 'Color', electrode_color);
end

L = plot(nan, nan, 'Color', 'k');
label = {strcat("square size = ", num2str(trace_scale), " uV")};
legend(L, label)  