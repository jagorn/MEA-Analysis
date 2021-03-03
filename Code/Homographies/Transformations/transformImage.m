function [t_img, t_ref] = transformImage(h, img, img_ref)

t = projective2d(transpose(h));

if ~exist('img_ref', 'var')
    [t_img, t_ref] = imwarp(img, t, 'interp', 'nearest');
else
    [t_img, t_ref] = imwarp(img, img_ref, t, 'interp', 'nearest');
end
