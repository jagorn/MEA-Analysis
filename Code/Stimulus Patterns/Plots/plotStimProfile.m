function plotStimProfile(stim_pattern, stim_rate, scale)
stim_period = 1/stim_rate;
y = stim_pattern * scale / max(stim_pattern);
x = cumsum(ones(size(stim_pattern))*stim_period) - stim_period;
plot(x, y, 'Color', [0.6, .6, 0.6], 'LineWidth', 1)

