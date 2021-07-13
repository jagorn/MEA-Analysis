function addHoloPositions(exp_id)

holo_table = getHolographyTable(exp_id);

for i_section = 1:numel(holo_table)
    holo_section = holo_table(i_section);
    dh_section = holo_section.stimulus;
    dh_conditions = holo_section.conditions;
    
    % look for an image to register the spots position
    img_id_found = false;
    for condition = dh_conditions
        try
            h_img2mea = getHomography(strcat("CAMERA_", condition), "MEA", exp_id);
            fprintf('\nSession %s: the pattern positions will be registered respect to the image %s.\n', dh_section, condition)
            img_id_found = true;
            break;
        end
    end
    
    if ~img_id_found
        h_img2mea = getHomography("CAMERA_X40", "MEA");
        fprintf('\nno image to register was found for session %s. The pattern positions will be registered respect to the default image.\n', dh_section)
    end
    
    try
        holo_positions_img = getHolographyPositionsImg(exp_id, dh_section);
        holo_positions_mea = transformPointsV(h_img2mea, holo_positions_img);
        holo_table(i_section).positions.img = holo_positions_img;
        holo_table(i_section).positions.mea = holo_positions_mea;
    catch
        fprintf('no holography patterns found for stimulus %s.\n', dh_section);
    end
end
setHolographyTable(exp_id, holo_table);