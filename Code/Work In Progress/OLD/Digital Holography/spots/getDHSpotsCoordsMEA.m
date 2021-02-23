function spots_coords = getDHSpotsCoordsMEA(dh_session, spots_pattern)

if exist('spots_pattern', 'var')
    spots_coords = dh_session.spots.coords_mea(spots_pattern, :);
else
    spots_coords = dh_session.spots.coords_mea;
end
