function plotStimStates(stim_pattern, stim_rate, scale, state_is_luminance)

stim_period = 1/stim_rate;
x = cumsum(ones(size(stim_pattern))*stim_period) - stim_period;

n_states = max(stim_pattern);
colors = getColors(n_states);

prev_state = 0;
current_block = 0;
block_start = 0;

for i_state = 1:numel(stim_pattern)
    state = stim_pattern(i_state);
    x_state = x(i_state);
    
    % detect new state
    if prev_state ~= state
        if current_block ~= 0 || state_is_luminance
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