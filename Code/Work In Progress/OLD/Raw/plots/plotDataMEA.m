function plotDataMEA(waves, mea_map, color, dead_electrodes, stim_electrodes)

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
[mea_size, chunk_size] = size(waves);

x_wave = linspace(-0.45, +0.45, chunk_size);

for i_electrode = 1:mea_size
    x_mea = mea_map(i_electrode, 1);
    y_mea = mea_map(i_electrode, 2);
    
    x_plot = x_wave + x_mea;
    y_plot = waves(i_electrode, :) * volt_factor + y_mea;
    
    if any(i_electrode == dead_electrodes)
        electrode_color = 'red';
    elseif any(i_electrode == stim_electrodes)
        electrode_color = 'k';
    else
        electrode_color = color;
    end
    plot(x_plot, y_plot, electrode_color);
end
