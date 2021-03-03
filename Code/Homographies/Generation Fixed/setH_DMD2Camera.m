function setH_DMD2Camera(varargin)

size_dmd_def = [1020, 760];
size_photo_def = [512, 672];
pxl_size_photo_def = 0.64;
pxl_size_dmd_def = 2.5;

% Parse Input
p = inputParser;
addParameter(p, 'Size_DMD', size_dmd_def);
addParameter(p, 'Size_Photo', size_photo_def);
addParameter(p, 'Pixel_Size_DMD', pxl_size_dmd_def);
addParameter(p, 'Pixel_Size_Photo', pxl_size_photo_def);

parse(p, varargin{:});

size_dmd = p.Results.Size_DMD;
size_photo = p.Results.Size_Photo;
pxl_size_dmd = p.Results.Pixel_Size_DMD;
pxl_size_photo = p.Results.Pixel_Size_Photo;


t_pre = size_dmd;
r = pi/2;
s = pxl_size_dmd / pxl_size_photo;
t_post = size_photo;

[H, H_inv] = buildH(t_pre, r, s, t_post);

addHomography(H, 'DMD', 'CAMERA')
addHomography(H_inv, 'CAMERA', 'DMD')