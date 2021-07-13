function [colors, color_map] = value2HeatColor(values, min_value, max_value, two_sides)

if ~exist('two_sides', 'var')
    two_sides = false;
end

interval = max_value - min_value;
values = values - min_value;
values(values < 1) = 1;
values(values > interval) = interval;
values(isnan(values)) = interval;
values = round(values);

size = round(interval + 1);

if two_sides
    color_map = flip(jet(size));
else
    full_map = flip(hot(size + round(interval/2)));
    color_map = full_map(round(interval/2):end, :);
end
colors = color_map(values, :); 
