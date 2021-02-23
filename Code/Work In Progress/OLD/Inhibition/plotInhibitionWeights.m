function plotInhibitionWeights(i_cell, session_label_normal, session_label_inhibition, varargin)

% Default Parameters
is_subfigure_default = false;
margins_microns_default = 50;
with_labels_default = false;
bins_default = [];

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'session_label_normal');
addRequired(p, 'session_label_inhibition');
addParameter(p, 'Bins', bins_default);
addParameter(p, 'Is_Subfigure', is_subfigure_default);
addParameter(p, 'Margins_Microns', margins_microns_default);
addParameter(p, 'Labels', with_labels_default, @islogical);

parse(p, i_cell, session_label_normal, session_label_inhibition, varargin{:});
bins = p.Results.Bins;
is_sub_figure = p.Results.Is_Subfigure;
margins = p.Results.Margins_Microns; 
with_labels = p.Results.Labels; 
   
% get session
s_normal = load(getDatasetMat(), session_label_normal);
s_inhibition = load(getDatasetMat(), session_label_inhibition);
session_normal = s_normal.(session_label_normal);
session_inhibition = s_inhibition.(session_label_inhibition);
id_session = session_inhibition.sessions(1);
exp_id = getExpId();

% get STA and transform it
sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(id_session)], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);
spots_2mea = getDHSpotsCoordsMEA(session_normal);

% get weights:
% if a model was provided, use the model weights;
% otherwise, use 1-spot firing rates.
fr_normal = get1SpotFiringRates(session_normal, i_cell);
fr_inhibition = get1SpotFiringRates(session_inhibition, i_cell);

if isempty(bins)
    bins = 1:size(fr_normal, 2);
end
w = mean(fr_normal(:, bins), 2) - mean(fr_inhibition(:, bins), 2);

% plot image
if ~is_sub_figure
    figure()
    fullScreen()
end
img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on

% plot weights
scatter(spots_2mea(:,1), spots_2mea(:,2), 60, w, "Filled")
if with_labels 
    text(spots_2mea(:,1) + 1.5, spots_2mea(:,2), string(1:size(spots_2mea, 1)));
end

% plot receptive field
load(getDatasetMat, "spatialSTAs");
rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);    
[x, y] = boundary(rf);
[cx, cy] = centroid(rf);

width_x = max(abs(cx - spots_2mea(:,1))) + margins;
width_y = max(abs(cy - spots_2mea(:,2))) + margins;
width = max(width_x, width_y);

plot(x, y, 'k', 'LineWidth', 3);

%  labels and colorbars
xlabel('Microns');
ylabel('Microns');
bar_label = 'Firing Rate Difference (Hz)';

colorMap = colorbarBlueRed();
colormap(colorMap);
c = colorbar;
c.Label.String = bar_label;
caxis([-max(abs(w)), max(abs(w))])



set(gcf,'Position',[0, 0, 1000, 1000]);
xlim([cx-width, cx+width])
ylim([cy-width, cy+width])


% Plot white disc
[cx, cy] = transformPoints(H2*H1, 38/2, 51/2);
radius = 150;
viscircles([cx, cy], radius, 'Color', 'w');

