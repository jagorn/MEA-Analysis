function spots_coords = getDHSpotsPositions(dh_session, spots_pattern)

if exist('spots_pattern', 'var')
    spots_coords = dh_session.spots.coords_laser(spots_pattern, :);
else
    spots_coords = dh_session.spots.coords_laser;
end
