function plotActivations(i_cell, psth_pattern, psth_label, activation_labels, varargin)
% Funtion to plot a cell's psth and its activation to a certain stimulus

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'psth_pattern');
addRequired(p, 'psth_label');
addRequired(p, 'activation_labels');
addParameter(p, 'Colors_Active_One', []);
addParameter(p, 'Color_Active_All', 'red');
addParameter(p, 'Color_Inactive', 'k');
addParameter(p, 'Show_Stimulus', 'trace');  % it can be 'trace', 'blocks' or 'none'
addParameter(p, 'Show_Stimulus_Block_As_Luminance', false)
addParameter(p, 'Upper_Bound', 50);
addParameter(p, 'Show_Legend', true);
addParameter(p, 'PSTHS', []);
addParameter(p, 'ACTIVATIONS', []);

parse(p, i_cell, psth_pattern, psth_label, activation_labels, varargin{:});
color_active_one = p.Results.Colors_Active_One;
color_active_all = p.Results.Color_Active_All;
color_inactive = p.Results.Color_Inactive;
show_stimulus = p.Results.Show_Stimulus;
show_blocks_as_luminance = p.Results.Show_Stimulus_Block_As_Luminance;
max_psth = p.Results.Upper_Bound;
show_legend = p.Results.Show_Legend;
psths = p.Results.PSTHS;
activations = p.Results.ACTIVATIONS;

n_conditions = numel(activation_labels);
if n_conditions < 2
    error_struct.message = "Activations must be at least 2. For plotting single activations use function plotActivation instead.";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


% if colors are not provided, generate them.
% Remove red (#2) and black (#4) which are used for ACTIVE_ALL and INACTIVE conditions.
if isempty(color_active_one)
    color_active_one = getColors(n_conditions + 2);
    color_active_one(4, :) = [];
    color_active_one(2, :) = [];
end

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

zs = false(n_conditions, 1);
thresholds = zeros(n_conditions, 1);
resp_wins = zeros(n_conditions, 2);

for i_activation = 1:n_conditions
    activation = activation_labels{i_activation};
    
    zs(i_activation) = activations.(psth_pattern).(psth_label).(activation).z(i_cell);
    thresholds(i_activation) = activations.(psth_pattern).(psth_label).(activation).threshold(i_cell);
    resp_wins(i_activation, :) = activations.(psth_pattern).(psth_label).(activation).params.resp_win;
end

% choose the correct color
if all(zs)
    color = color_active_all;
elseif all(~zs)
    color = color_inactive;
else
    activated_colors = color_active_one(zs, :);
    color = activated_colors(1, :);
end

% plot the stimulus in the background
ylim([0, max_psth*1.1])
hold on

if strcmp(show_stimulus, 'trace')
    plotStimProfile(stim_pattern.profile, stim_rate, 'Scale', max_psth);
elseif strcmp(show_stimulus, 'blocks')
    plotStimStates(stim_pattern.profile, stim_rate, 'Scale', max_psth, 'States_Luminance', show_blocks_as_luminance);
end

% plot the psth
plot(x_psth, psth, 'Color', color,  'LineWidth', 2);

% add the thresholds
for i_activation = 1:n_conditions
    threshold = thresholds(i_activation);
    resp_win = resp_wins(i_activation, :);
    color_threshold = color_active_one(i_activation, :);
    plot(resp_win, [threshold threshold], 'Color', [color_threshold 0.5], 'LineWidth', 5);
end

if show_legend
    for i_activation = 1:n_conditions
        L(i_activation) = plot(nan, nan, 'Color', color_active_one(i_activation, :));
    end
    L(n_conditions + 1) = plot(nan, nan, 'Color', color_active_all);
    L(n_conditions + 2) = plot(nan, nan, 'Color', color_inactive);
    activation_labels{n_conditions + 1} = 'all';
    activation_labels{n_conditions + 2} = 'none';
    legend(L, activation_labels)    
end
