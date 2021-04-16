function plotActivation(i_cell, psth_pattern, psth_label, activation, varargin)
% Funtion to plot a cell's psth and its activation to a certain stimulus

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'psth_pattern');
addRequired(p, 'psth_label');
addRequired(p, 'activation');
addParameter(p, 'Color_Active', 'red');
addParameter(p, 'Color_Inactive', 'k');
addParameter(p, 'Show_Stimulus', 'trace');  % it can be 'trace', 'blocks' or 'none'
addParameter(p, 'Upper_Bound', 50);
addParameter(p, 'PSTHS', []);
addParameter(p, 'ACTIVATIONS', []);

parse(p, i_cell, psth_pattern, psth_label, activation, varargin{:});
color_active = p.Results.Color_Active;
color_inactive = p.Results.Color_Inactive;
show_stimulus = p.Results.Show_Stimulus;
max_psth = p.Results.Upper_Bound;
psths = p.Results.PSTHS;
activations = p.Results.ACTIVATIONS;

% If the PSTHS and ACTIVATIONS were not passed, load them
if isempty(psths)
    load(getDatasetMat, 'psths');
end
if isempty(activations)
    load(getDatasetMat, 'activations');
end

% Load all the variables from the structures
psth = psths.(psth_pattern).(psth_label).psths(i_cell, :);
x_psth = psths.(psth_pattern).(psth_label).time_sequences;

stim_pattern = getPatternProfile(psth_pattern);
stim_rate =  psths.(psth_pattern).(psth_label).stim_rate;

z = activations.(psth_pattern).(psth_label).(activation).z(i_cell);
threshold = activations.(psth_pattern).(psth_label).(activation).threshold(i_cell);
resp_win = activations.(psth_pattern).(psth_label).(activation).params.resp_win;

% choose the correct color
if z
    color = color_active;
else
    color = color_inactive;
end

% plot the stimulus in the background
hold on
if strcmp(show_stimulus, 'trace')
    plotStimProfile(stim_pattern.profile, stim_rate, 'Scale', max_psth);
elseif strcmp(show_stimulus, 'blocks')
    plotStimStates(stim_pattern.profile, stim_rate, 'Scale', max_psth);
end

% add the psth and the threshold
plot(x_psth, psth, color, 'LineWidth', 2);
plot(resp_win, [threshold threshold], color, 'LineWidth', 5);
ylim([0 max_psth])


