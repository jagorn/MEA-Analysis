function plotDHWeights(i_cell, session_label, varargin)

% Default Parameters
model_label_default = [];
is_subfigure_default = false;
margins_microns_default = 50;
with_labels_default = false;

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'session_label');
addParameter(p, 'Model', model_label_default);
addParameter(p, 'Is_Subfigure', is_subfigure_default);
addParameter(p, 'Margins_Microns', margins_microns_default);
addParameter(p, 'Labels', with_labels_default, @islogical);

parse(p, i_cell, session_label, varargin{:});
model_label = p.Results.Model;
is_sub_figure = p.Results.Is_Subfigure;
margins = p.Results.Margins_Microns; 
with_labels = p.Results.Labels; 
   
% get session
s = load(getDatasetMat(), session_label);
dh_session = s.(session_label);
id_session = dh_session.sessions(1);
exp_id = getExpId();

% get STA and transform it
sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(id_session)], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);
spots_2mea = getDHSpotsCoordsMEA(dh_session);

% get weights:
% if a model was provided, use the model weights;
% otherwise, use 1-spot firing rates.
if isempty(model_label)
    w = get1SpotFiringRates(dh_session, i_cell);
    colorMap = colorbarWhiteRed();
    bar_label = 'Firing Rates (Hz)';
    title_2 = 'firing-rate on 1-spot patterns';
else
    [w, a, b] = getDHLNPWeights(dh_session, model_label, i_cell);
    accuracy = getDHLNPAccuracies(dh_session, model_label, i_cell);
    accuracy(isnan(accuracy)) = 0;
    colorMap = colorbarBlueRed();
    bar_label =  'normalized weights';
    title_2 =   [model_label ': acc=' num2str(accuracy) ...
                '. r = exp(aW .* I + b)   <a = '  num2str(a) ...
                ',   b = '  num2str(b) '>'];
end

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

colormap(colorMap);
c = colorbar;
c.Label.String = bar_label;

% title and centering
title_1 = [char(session_label ) ', Cell #' num2str(i_cell)];
title({title_1, title_2}, 'interpreter', 'none');

set(gcf,'Position',[0, 0, 1000, 1000]);
xlim([cx-width, cx+width])
ylim([cy-width, cy+width])