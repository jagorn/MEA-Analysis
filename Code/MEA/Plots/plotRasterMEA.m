function plotRasterMEA(spike_times, evt_timesteps, evt_binsize, evt_spacing, mea_rate, mea_map, varargin)
% show a multi-unit raster plot for an MEA.
%
% INPUTS
% SPIKE TIMES:              a cell array containing a spike train for each electrode
% EVT_TIMESTEPS:            the beginning of each repetition (time steps)
% EVT_BINSIZE:              the interval of the raster (time steps)
% MEA_RATE:                 sampling rate of the MEA
% MEA_MAP:                  the electrode-to-position map
% MAX_REPS (OPTIONAL):  	the maximum number of repetitions to show.


% Parameters Default
mea_channels_def = 1:size(mea_map, 1);
n_max_rep_def = 30;

% Parse Input
p = inputParser;
addRequired(p, 'spike_times');
addRequired(p, 'evt_timesteps');
addRequired(p, 'evt_binsize');
addRequired(p, 'evt_spacing');
addRequired(p, 'mea_rate');
addRequired(p, 'mea_map');
addParameter(p, 'Max_Repetitions', n_max_rep_def);

parse(p, spike_times, evt_timesteps, evt_binsize, evt_spacing, mea_rate, mea_map, varargin{:});
n_max_rep = p.Results.Max_Repetitions; 

timesteps_stim = evt_binsize + evt_spacing*2;
dt_stim = timesteps_stim / mea_rate;
    
plotMEA();
plotGridMEA();
hold on
for i_channel = 1:numel(spike_times)
    spikes = spike_times{i_channel};

    [x, y] = raster(spikes, evt_timesteps - evt_spacing, evt_timesteps + evt_binsize + evt_spacing, mea_rate);
    
    if isempty(x)
        continue;
    end
    
    x_norm = x / dt_stim;
    y_norm = y / n_max_rep;
    
    x_plot = x_norm + double(mea_map(i_channel, 1)) - 0.5;
    y_plot = y_norm + double(mea_map(i_channel, 2)) - 0.5;
    
    if mod(mea_map(i_channel, 1) - mea_map(i_channel, 2), 2)
        c = [.6, .4, .6];
    else
        c = [.4, .4, .7];
    end
    
    scatter(x_plot, y_plot, 30, c, '.')  
end

if evt_spacing ~= 0
    onset_norm = evt_spacing / timesteps_stim;
    offset_norm = (timesteps_stim - evt_spacing) / timesteps_stim;

    for i_row = 1:16
        xline(onset_norm + i_row - 0.5, 'g--', 'LineWidth', 1);
        xline(offset_norm + i_row - 0.5, 'r--', 'LineWidth', 1);
    end
end