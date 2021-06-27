function [dead_init, dead_end] = computeDeadIntervals(residual, time_spacing, varargin)

% Params
dead_threshold_def = 300;    % uV
dead_padding_def = 250;     % steps

% Parse input
p = inputParser();
addRequired(p, 'residual');
addRequired(p, 'time_spacing');
addParameter(p, 'Threshold_mV', dead_threshold_def);
addParameter(p, 'Padding_Time_Steps', dead_padding_def);

parse(p, residual, time_spacing, varargin{:});
dead_threshold = p.Results.Threshold_mV;
dead_padding = p.Results.Padding_Time_Steps;

% Compute
block_times = residual > dead_threshold;
    
dead_init = find((diff(block_times) > 0)) - dead_padding - time_spacing;
dead_end = find((diff(block_times) < 0)) + dead_padding - time_spacing;

there_are_intersections = true;
while there_are_intersections
    there_are_intersections = false;

    for i = 1:length(dead_end) - 1
        if dead_end(i) > dead_init(i + 1)
            dead_end(i) = dead_end(i + 1);
            dead_init(i + 1) = [];
            dead_end(i + 1) = [];

            there_are_intersections = true;
            break
        end
    end
end