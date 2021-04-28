function plotRawMEA(raw_file, time_step, chunk_size, mea_map, varargin)


% Default Parameters
dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
color_def = 'k';
color_stim_def = 'b';
color_dead_def = 'r';
encoding_def = 'uint16';

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addRequired(p, 'time_step');
addRequired(p, 'chunk_size');
addRequired(p, 'mea_map');
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'Color', color_def);
addParameter(p, 'Color_Stim', color_stim_def);
addParameter(p, 'Color_Dead', color_dead_def);
addParameter(p, 'Encoding', encoding_def);

parse(p, traces, mea_map, varargin{:});

dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
color = p.Results.Color;
color_stim = p.Results.Color_Stim;
color_dead = p.Results.Color_Dead;

mea_size = size(mea_map, 1);
waves = extractDataMEA(raw_file, time_step, chunk_size, mea_size, encoding);
waves = reshape(waves, mea_size, chunk_size)/10;

plotTracesMEA(waves, mea_map, 'Dead_Electrodes', dead_electrodes, ...
                              'Stim_Electrodes', stim_electrodes, ...
                              'Color', color, ...
                              'Color_Stim', color_stim, ...
                              'Color_Dead', color_dead)
