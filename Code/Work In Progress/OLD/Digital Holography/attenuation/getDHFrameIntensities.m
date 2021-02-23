function frames_intensities = getDHFrameIntensities(dh_session, patterns)

spots_coords = getDHSpotsPositions(dh_session);
n_frames = size(patterns, 1);
n_spots = size(patterns, 2);

frames_intensities = zeros(n_frames, n_spots);
for i_pattern = 1:n_frames
    pattern = patterns(i_pattern, :);
    for i_spot = find(pattern)
        intensity = pattern(i_spot) * spot_attenuation(spots_coords(i_spot, 1), spots_coords(i_spot, 2));
        frames_intensities(i_pattern, i_spot) = intensity;
    end
end

