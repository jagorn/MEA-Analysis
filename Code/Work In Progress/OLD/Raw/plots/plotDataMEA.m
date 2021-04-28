function plotRawMEA(traces, mea_map, color, dead_electrodes, stim_electrodes)


% Default Parameters
dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
color_def = [];
color_stim_def = 0.2;
color_dead_def = 'uint16';


% Parse Input
p = inputParser;
addRequired(p, 'triggers');
addRequired(p, 'mea_rate');
addParameter(p, 'Artifact', artifact_def);
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'Frame_Duration', frame_duration_def);
addParameter(p, 'Time_Padding', time_padding_def);
addParameter(p, 'Endcoding', encoding_def);
addParameter(p, 'MEA_Map', mea_map_def);

parse(p, triggers, mea_rate, raw_file, varargin{:});

artifact = p.Results.Artifact;
dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
frame_duration = p.Results.Frame_Duration;
time_padding = p.Results.Time_Padding;
encoding = p.Results.Endcoding;
mea_map = p.Results.MEA_Map;

if ~exist('color', 'var')
    color = 'blue';
end

if ~exist('dead_electrodes', 'var')
    dead_electrodes = [];
end

if ~exist('stim_electrodes', 'var')
    stim_electrodes = [127 128 255 256];
end

volt_factor = 0.001;
[mea_size, chunk_size] = size(traces);

x_wave = linspace(-0.45, +0.45, chunk_size);

for i_electrode = 1:mea_size
    x_mea = mea_map(i_electrode, 1);
    y_mea = mea_map(i_electrode, 2);
    
    x_plot = x_wave + x_mea;
    y_plot = traces(i_electrode, :) * volt_factor + y_mea;
    
    if any(i_electrode == dead_electrodes)
        electrode_color = 'red';
    elseif any(i_electrode == stim_electrodes)
        electrode_color = 'k';
    else
        electrode_color = color;
    end
    plot(x_plot, y_plot, electrode_color);
end
