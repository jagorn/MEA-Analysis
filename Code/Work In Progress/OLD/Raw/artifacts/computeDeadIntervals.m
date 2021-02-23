function [dead_init, dead_end] = computeDeadIntervals(residual, time_spacing)

dead_threshold = 300;    % mV
dead_padding = 250;     % steps

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