function plotStimStates(stim_pattern, stim_rate, varargin)
% Plots the temporal profile of a stimululs with state blocks.

% PARAMETERS:
% stim_Pattern:                 the name of the stimulus pattern
% stim_rate:                    the frame rate at which the stimulus is played.
% scale (optional):             the height of blocks
% color (optional):             the colors of the blocks
% states_luminance (optional):  if true, the state values are used as grayscale colors for the blocks (1 to 255)
% state_0 (optional):           if true, 0 is also considered as a state.

n_states = max(stim_pattern);

% Parse Input
p = inputParser;
addRequired(p, 'stim_pattern');
addRequired(p, 'stim_rate');
addParameter(p, 'Scale', 1);
addParameter(p, 'Colors', getColors(n_states + 1));
addParameter(p, 'States_Luminance', false);
addParameter(p, 'Exclude_0', true);

parse(p, stim_pattern, stim_rate, varargin{:});
scale = p.Results.Scale;
colors = p.Results.Colors;
state_is_luminance = p.Results.States_Luminance;
exclude_0 = p.Results.Exclude_0;

stim_period = 1/stim_rate;
xs = cumsum(ones(size(stim_pattern))*stim_period) - stim_period;

prev_state = 0;
current_block = 0;
block_start = 0;

for i_state = 1:numel(stim_pattern)
    state = stim_pattern(i_state);
    x_state = xs(i_state);
    
    % detect new state
    if prev_state ~= state
        if ~(current_block == 0 && exclude_0)
            if state_is_luminance
                color = [current_block/255 current_block/255 current_block/255 0.5];
                rectangle('Position', [block_start, 0, x_state-block_start, scale], 'EdgeColor', 'k', 'FaceColor', color);
            else
                color = [colors(current_block, :) 0.5];
                rectangle('Position', [block_start, 0, x_state-block_start, scale], 'EdgeColor', 'None', 'FaceColor', color);
            end
        end
        current_block = state;
        block_start = x_state;
    end
    
    prev_state = state;
end

if current_block ~= 0 || state_is_luminance
    if state_is_luminance
        color = [current_block/255 current_block/255 current_block/255 0.5];
        rectangle('Position', [block_start, 0, x_state-block_start + stim_period, scale], 'EdgeColor', 'k', 'FaceColor', color);
    else
        color = [colors(current_block, :) 0.5];
        rectangle('Position', [block_start, 0, x_state-block_start + stim_period, scale], 'EdgeColor', 'None', 'FaceColor', color);
    end
end