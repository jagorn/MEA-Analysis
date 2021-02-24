function [z_scores, psths] =  computeActivations(spikes, evt_times, evt_dt, evt_order, mea_rate, varargin)

% Default Parameters
bin_dt_def = 0.025;
sigma_def = 6;
min_firing_rate_def = 15;

control_window_def = [-0.250, -0.050];
response_window_def = [+0.100, +0.400];
spacing_def = 0.250;

mu_channels_def = [1:126, 129:254];

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 'evt_times');
addRequired(p, 'evt_dt');
addRequired(p, 'evt_order');
addRequired(p, 'mea_rate');

addParameter(p, 'Time_Bin', bin_dt_def);
addParameter(p, 'Z_Sigma', sigma_def);
addParameter(p, 'Z_Min_Firing_Rate', min_firing_rate_def);
addParameter(p, 'Control_Window', control_window_def);
addParameter(p, 'Response_Window', response_window_def);
addParameter(p, 'Spacing', spacing_def);
addParameter(p, 'Channels', mu_channels_def);

addParameter(p, 'MEA_Map', [])
addParameter(p, 'Plot_Psths', false);
addParameter(p, 'Plot_Activation', false);

% Assign Parameters
parse(p, spikes, evt_times, evt_dt, evt_order, mea_rate, varargin{:});
t_bin = p.Results.Time_Bin;
sigma = p.Results.Z_Sigma;
min_fr = p.Results.Z_Min_Firing_Rate;
w_control = p.Results.Control_Window;
w_response = p.Results.Response_Window;
spacing = p.Results.Spacing;
channels = p.Results.Channels;

do_plots = p.Results.Plot_Psths;
do_activation = p.Results.Plot_Activation;
mea_map = p.Results.MEA_Map;

% Initialize values
evt_ids = unique(evt_order);
n_channels = numel(channels);
n_patterns = numel(evt_ids);

w_event = (evt_dt/mea_rate + spacing*2);
n_bins = round(w_event /t_bin);

ctrl = w_control + spacing;
rsp = w_response + spacing;

z_scores = zeros(n_channels, n_patterns);
psths = zeros(n_channels, n_patterns, n_bins);

% Compute PSTHs and Z scores
for i_pattern = 1:n_patterns
    
    frame_id = evt_ids(i_pattern);
    frame_times = evt_times(evt_order == frame_id);
    repetitions = frame_times - spacing*mea_rate;
    
    [psth, x_psth] = doPSTH(spikes, repetitions, t_bin*mea_rate, n_bins,  mea_rate, 1:n_channels);
    z_scores(:, i_pattern) = estimateZscore(psth, x_psth, ctrl, rsp, sigma, min_fr);
    psths(:, i_pattern, :) = psth;
end

if do_activation
    fullScreen();
    imagesc(z_scores')
    xticks(1:10:n_channels);
    yticks(1:n_patterns);
    xlabel('MEA Channels');
    ylabel('Patterns');
    title('Pattern Activations');
end

if do_plots
    
    if isempty(mea_map)
        warning("you cannot plot the PSTHs: mea_map parameter is missing");
        return
    end
    
    for i = 1:n_patterns
        % inizialize all channel colors to black
        colors = zeros(n_channels, 3);
        % assign red color to channels with z = 1
        colors(z_scores(:, i) == 1, 3) = 1;

        plotMEA();
        plotGridMEA();

        plotPsthMEA(squeeze(psths(:, i, :)), w_event, mea_map, 'Colors', colors, 'Offset', spacing)
        title(strcat("Pattern #", num2str(i)))
        waitforbuttonpress();
        close();
    end
end