function plotVisualHoloCards(exp_id, visual_section, holo_sections, position, varargin)
% Plots a panel with all information  for each cell


% INPUTS:
% One_By_One (optional):	if true, panels are shown one by one.
%                           user has to click on a panel to close it,
%                           then the following panel will show up.
% Save (optional):          if true, each panel is saved in the PLOTS folder.

% Parse Input
p = inputParser;
addParameter(p, 'Pattern_Indices', []);
addParameter(p, 'Pattern_Colors', []);
addParameter(p, 'One_By_One', false);
addParameter(p, 'Save', true);

parse(p, varargin{:});
p_indices = p.Results.Pattern_Indices;
p_colors = p.Results.Pattern_Colors;
one_by_one = p.Results.One_By_One;
do_save = p.Results.Save;

distance_matrix = getCell2PatternDistances(exp_id, holo_sections(1));
visual_minus_holo_score = compareHoloVisualActivations();

[~, ~, ~, valid_cells] = getSTAsComponents(exp_id);
for i_cell = valid_cells(:)'
    
%         [norm_scores, p_indices] = sortHoloPatternsByActivation(exp_id, holo_sections(1), i_cell);
%         p_colors = value2HeatColor(norm_scores, 0, 100);
    
    color_map_limits = [- 50, 50];
    norm_scores = squeeze(visual_minus_holo_score(i_cell, :));
    [~, p_indices] = sort(norm_scores);
    [p_colors, color_map] = value2HeatColor(norm_scores, color_map_limits(1), color_map_limits(2), true);
    
    plotVisualHoloCard(exp_id, i_cell, visual_section, holo_sections,  ...
        'Pattern_Indices', p_indices, ...
        'Pattern_Colors', p_colors, ...
        'Mode', 'raster', ...
        'Center_Microns', position, ...
        'Color_Map', color_map, ...
        'Color_Map_Limits', color_map_limits);
    
    if do_save
        file_name = strcat('VisualHoloComparison_ActivationsR#', num2str(i_cell));
        file_folder = fullfile(plotsPath(getDatasetId), 'Visual-Holography');
        
        if ~exist(file_folder, 'dir')
            mkdir(file_folder);
        end
        
        file_path = fullfile(file_folder, file_name);
        saveas(gcf, file_path,'jpg')
    end
    
    if one_by_one
        waitforbuttonpress()
    end
    close;
end


