function [rfs, roi_size] = rfs2roi(rfs, roi_corners)

roi_size = [roi_corners(3) - roi_corners(1), roi_corners(4) - roi_corners(2)];

for i_rf = 1:numel(rfs)
    rfs(i_rf).Vertices = rfs(i_rf).Vertices - [roi_corners(1), roi_corners(2)]/2;
end