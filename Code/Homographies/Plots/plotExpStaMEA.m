function plotExpStaMEA(exp_id, cell_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addParameter(p, 'Label', "");
addParameter(p, 'Image', "X10");
addParameter(p, 'Is_Subfigure', false);
addParameter(p, 'Width_Microns', 500);
addParameter(p, 'Center_Microns', []);

parse(p, exp_id, cell_id, varargin{:});
label = p.Results.Label;
img_id = p.Results.Image;
is_sub_figure = p.Results.Is_Subfigure;
width = p.Results.Width_Microns;
center = p.Results.Center_Microns;

[~, spatial, rfs, valid] = getSTAsComponents(exp_id, 'Label', label);
if all(valid ~= cell_id)
    warning(strcat('no valid STA defactorization found for cell #', num2str(cell_id)));
    return
end

rf = rfs(cell_id);
spatial_sta = squeeze(spatial(cell_id, :, :));

background = spatial_sta;
background = background - min(background(:));
background = background /max(background(:));

% Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography(strcat('CAMERA_', img_id), 'MEA');
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA * HDMD_2_Camera * HChecker_2_DMD;
[sta_2mea, staRef_2mea] = transformImage(HChecker_2_MEA, background);

% plot image
if ~is_sub_figure
    figure()
    fullScreen()
end

sta_2mea_color = cat(3, sta_2mea, sta_2mea, ones(size(sta_2mea))*0.4);
t = imshow(sta_2mea_color, staRef_2mea);
set(t, 'AlphaData', 0.5);
hold on

% plot Receptive Field
rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);    
[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 3);

set(gcf,'Position',[0, 0, 1000, 1000]);
if isempty(center)
    [cx, cy] = centroid(rf);
else
    cx = center(1);
    cy = center(2);
end
xlim([cx-width, cx+width])
ylim([cy-width, cy+width])

%  labels and colorbars
xlabel('Microns');
ylabel('Microns');

if ~exist('label', 'var') || isempty(label) || (label == "")
    text_title = strcat("Exp ", exp_id, " Cell# ", num2str(cell_id), ": Spike-Triggered Average");
else
    text_title = strcat("Exp ", exp_id, " Cell# ", num2str(cell_id), ": STA-", label);
end
t = title(text_title);
t.Interpreter = 'None';