function frames_intensities = getDHFrameNormIntensities(dh_session, patterns)

n_frames = size(patterns, 1);
n_spots = size(patterns, 2);
spots_coords = getDHSpotsPositions(dh_session);

frames_intensities = zeros(n_frames, n_spots);
for i_pattern = 1:n_frames
    pattern = logical(patterns(i_pattern, :));
    intensity = patternNormalizedIntensities(spots_coords(pattern, 1), spots_coords(pattern, 2));
    intensities = pattern .* intensity;
    frames_intensities(i_pattern, :) = intensities;
end