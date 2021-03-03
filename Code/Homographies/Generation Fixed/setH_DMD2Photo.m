function setH_DMD2Photo(n_pixels_square)

if ~exist('n_pixels_square', 'var')
    n_pixels_square = 20;
end

t_pre = [0, 0];
r = 0;
s = n_pixels_square;
t_post = [0, 0];

[H, H_inv] = buildH(t_pre, r, s, t_post);

addHomography(H, 'DMD', 'CHECKERBOARD')
addHomography(H_inv, 'CHECKERBOARD', 'DMD')