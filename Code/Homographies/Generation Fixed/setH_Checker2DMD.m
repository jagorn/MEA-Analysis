function setH_Checker2DMD(varargin)

n_pixels_square_def = 20;

% Parse Input
p = inputParser;
addParameter(p, 'Pixel_Size_Square', n_pixels_square_def);
parse(p, varargin{:});
n_pixels_square = p.Results.Pixel_Size_Square;


t_pre = [0, 0];
r = 0;
s = n_pixels_square;
t_post = [0, 0];

[H, H_inv] = buildH(t_pre, r, s, t_post);

checker_id = strcat('CHECKER', num2str(n_pixels_square));

addHomography(H, checker_id, 'DMD');
addHomography(H_inv, 'DMD', checker_id);
