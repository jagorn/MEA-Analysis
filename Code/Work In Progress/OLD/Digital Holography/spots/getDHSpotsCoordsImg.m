function spots_coords = getDHSpotsCoordsImg(dh_session, spots_pattern)

if exist('spots_pattern', 'var')
    spots_coords = dh_session.spots.coords_img(spots_pattern, :);
else
    spots_coords = dh_session.spots.coords_img;
end