function discs_reps = transformDiscs2MEA(discs_reps, exp_id, img_id)

Checkerboard_PxlsPerSquare = 20;

for i_disc = 1:numel(discs_reps)
    center_x_dmd = discs_reps(i_disc).center_x / Checkerboard_PxlsPerSquare;
    center_y_dmd = discs_reps(i_disc).center_y / Checkerboard_PxlsPerSquare;
    h1 = getHomography('dmd', 'img');
    h2 = getHomography(['img' num2str(img_id)], 'mea', exp_id);
    h = h2*h1;
    [center_x_mea, center_y_mea] = transformPoints(h, center_x_dmd, center_y_dmd);
    
    discs_reps(i_disc).center_x_dmd = center_x_dmd;
    discs_reps(i_disc).center_y_dmd = center_y_dmd;
    discs_reps(i_disc).center_x_mea = center_x_mea;
    discs_reps(i_disc).center_y_mea = center_y_mea;
end