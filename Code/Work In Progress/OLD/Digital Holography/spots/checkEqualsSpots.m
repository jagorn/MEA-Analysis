function coords = checkEqualsSpots(coords_set)

coords = coords_set{1};
for i = 1:numel(coords_set)
    if ~(coords == coords_set{i})
        error('Error: spots coords in session %i are not consistent with previos sessions', i)
    end
end
        