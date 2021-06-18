function plotStimProfile(stim_pattern, stim_rate, varargin)
% Plots the temporal profile of a stimululs.

% PARAMETERS:
% stim_Pattern: the name of the stimulus pattern
% stim_rate: the frame rate at which the stimulus is played.
% scale (optional): the scaling of the trace (max value after normalization)
% color (optional): the color of the trace

% Parse Input
p = inputParser;
addRequired(p, 'stim_pattern');
addRequired(p, 'stim_rate');
addParameter(p, 'Scale', 1);
addParameter(p, 'Time_Spacing', 0);
addParameter(p, 'Color', [0.6, .6, 0.6]);

parse(p, stim_pattern, stim_rate, varargin{:});
scale = p.Results.Scale;
t_spacing = p.Results.Time_Spacing;
color = p.Results.Color;

stim_period = 1/stim_rate;
y = stim_pattern * scale / max(stim_pattern);
x = cumsum(ones(size(stim_pattern))*stim_period) - stim_period + t_spacing;
plot(x, y, 'Color', color, 'LineWidth', 1)

