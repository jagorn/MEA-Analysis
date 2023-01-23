function rfs = rfsToMicrons(rfs, rf_unit_size, rf_size, roi_size)


for i_rf = 1:numel(rfs)
    rfs(i_rf).Vertices = rfs(i_rf).Vertices*rf_unit_size + (roi_size - rf_size)/2;
end