function f = plotHoloSTAMultiSpot(exp_id, cell_id, section_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'section_id');
addParameter(p, 'Width_Microns', 750);
addParameter(p, 'Center_Microns', [255, 255]);
addParameter(p, 'Pattern_Idx', []);
addParameter(p, 'Show_MEA', false);
addParameter(p, 'Show_Stimulus', false);
addParameter(p, 'Weights', []);
addParameter(p, 'Spot_Weights', []);
addParameter(p, 'Show_Colorbar', false);
addParameter(p, 'Max_Firing_rate', 30);
addParameter(p, 'Title', "");

parse(p, exp_id, cell_id, section_id, varargin{:});
width = p.Results.Width_Microns;
center = p.Results.Center_Microns;
patterns = p.Results.Pattern_Idx;
show_mea = p.Results.Show_MEA;
show_stimulus = p.Results.Show_Stimulus;
pattern_weights = p.Results.Weights;
spot_weights = p.Results.Spot_Weights;
show_colorbar = p.Results.Show_Colorbar;
fr_max = p.Results.Max_Firing_rate;
title_text = p.Results.Title;

[holo_section , i_section] = getHoloSection(exp_id, section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_patterns = holo_psth.psth.patterns;
holo_positions = holo_psth.psth.pattern_positions.mea;

n_all_spots = size(holo_positions, 1);
if isempty(patterns)
    n_patterns = size(holo_patterns, 1);
    patterns = 1:n_patterns;
else
    n_patterns = numel(patterns);
end

if isempty(spot_weights)
    if isempty(pattern_weights)
        pattern_weights = holo_psth.activations.scores(patterns, cell_id);
    end
    
    spots_weights_list = cell(1, n_all_spots);
    for i_pattern = 1:n_patterns
        pattern = patterns(i_pattern);
        weight = pattern_weights(i_pattern);
        spots = find(holo_patterns(pattern, :));
        for spot = spots(:)'
            spots_weights_list{spot} = [spots_weights_list{spot} weight];
        end
    end
    
    spots_weight_averages = nan(1, n_all_spots);
    for i_spot = 1:n_all_spots
        spots_weight_averages(i_spot) = sum(spots_weights_list{i_spot}) / numel(spots_weights_list{i_spot});
    end
    spots = find(~isnan(spots_weight_averages));
    spot_weights = spots_weight_averages(~isnan(spots_weight_averages));
    n_spots = numel(spots);
else
    n_spots = size(holo_positions, 1);
    spots = 1:n_spots;
end


[colors, colorbar] = value2HeatColor(spot_weights, -fr_max, +fr_max, true);

f = figure(245245);
plotExpStaMEA(exp_id, cell_id, 'Is_Subfigure', true, 'Width_Microns', width, 'Center', center);
pause(2);

if show_stimulus
    % Load Homographies
    HDMD_2_Camera = getHomography('DMD', 'CAMERA');
    HCamera_2_MEA_Fluo = getHomography(holo_section.h_ref, 'MEA', exp_id);
    
    % Compose Homographies
    HStim_2_MEA = HCamera_2_MEA_Fluo * HDMD_2_Camera;
    
    % Add visual stim
    c = getDMDStimShape(holo_section.stimulus);
    c.Vertices = transformPointsV(HStim_2_MEA, c.Vertices);
    [xc, yc] = boundary(c);
    fill(xc, yc, 'w', 'FaceAlpha', 0.4);
end

pause(2);
figure(f);
for i_spot = 1:n_spots
    spot = spots(i_spot);
    color_spot = colors(i_spot, :);
    position_spot = holo_positions(spot, :);
    scatter(position_spot(1), position_spot(2), 100, color_spot, "Filled", 'MarkerEdgeColor', [0.1 0.1 0.1]);
end
title(title_text);
ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);
set(gcf,'Position',[width/2 - 350, height/2 - 350, 700, 700]);

if show_mea
    figure(f);
    plotElectrodesMEA();
end

if show_colorbar && (show_activation || ~isempty(pattern_weights))
    plotColorBar(colorbar, -fr_max, +fr_max, 'Firing Rate (Hz)')
end