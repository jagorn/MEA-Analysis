function all_coords = concatSpots(coords_set)

all_coords = [];
for i = 1:numel(coords_set)
    all_coords = [all_coords; coords_set{i}];
end
        