function [colors, color_map] = value2HeatColor(values, min_value, max_value, two_sides)

if ~exist('two_sides', 'var')
    two_sides = false;
end

n_intervals = round(max_value - min_value);
shades_ratio = 100 / n_intervals;

values = values * shades_ratio;
min_value = round(min_value * shades_ratio);
max_value = round(max_value * shades_ratio);

interval = max_value - min_value;
values = values - min_value;
values(values < 1) = 1;
values(values > interval) = interval;
values(isnan(values)) = interval;
values = round(values);

size = round(interval + 1);

if two_sides
    color_map = customColorMap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'}, interval);
else
    color_map = customColorMap(linspace(0,1,6), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3'}, interval);
end
colors = color_map(values, :); 
