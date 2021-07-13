function plotHoloSTA(exp_id, cell_id, section_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'section_id');
addParameter(p, 'Label', "");
addParameter(p, 'Image', "X10");
addParameter(p, 'Is_Subfigure', false);
addParameter(p, 'Width_Microns', 500);
addParameter(p, 'Center_Microns', []);
addParameter(p, 'Pattern_Colors', []);

parse(p, exp_id, cell_id, section_id, varargin{:});
label = p.Results.Label;
img_id = p.Results.Image;
is_sub_figure = p.Results.Is_Subfigure;
width = p.Results.Width_Microns;
center = p.Results.Center_Microns;
colors = p.Results.Pattern_Colors;

[~ , i_section] = getHoloSection(exp_id, section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_patterns = holo_psth.psth.patterns;
holo_positions = holo_psth.psth.pattern_positions.mea;

n_patterns = size(holo_patterns, 1);
if isempty(colors)
    colors = getColors(n_patterns);
end

hold on;
plotExpStaMEA(exp_id, cell_id, 'Label', label, 'Image', img_id, 'Is_Subfigure', is_sub_figure, 'Width_Microns', width, 'Center', center);
plotVisualStimMEA();

for i_pattern = 1:n_patterns
    color_pattern = colors(i_pattern, :);
    spots_pattern_idx = logical(holo_patterns(i_pattern, :));
    position_pattern = holo_positions(spots_pattern_idx, :);
    scatter(position_pattern(:,1), position_pattern(:,2), 25, color_pattern, "Filled");
end
plotElectrodesMEA();