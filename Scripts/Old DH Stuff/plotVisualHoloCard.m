function plotVisualHoloCard(exp_id, cell_id, visual_section_id, holo_sections_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addParameter(p, 'Label', "");
addParameter(p, 'Image', "X10");
addParameter(p, 'Mode', 'psth'); % raster or psth
addParameter(p, 'Pattern_Indices', []);
addParameter(p, 'Pattern_Colors', []);
addParameter(p, 'Width_Microns', 500);
addParameter(p, 'Center_Microns', []);
addParameter(p, 'Color_Map', []);
addParameter(p, 'Color_Map_Limits', []);

parse(p, exp_id, cell_id, varargin{:});
label = p.Results.Label;
img_id = p.Results.Image;
mode = p.Results.Mode;
p_indices = p.Results.Pattern_Indices;
p_colors = p.Results.Pattern_Colors;
width = p.Results.Width_Microns;
center = p.Results.Center_Microns;
color_map = p.Results.Color_Map;
color_map_limits = p.Results.Color_Map_Limits;

% Visual
rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);
visual_repetitions = getRepetitions(exp_id, visual_section_id);

% Holo
holo_psths = getHolographyPSTHs(exp_id);
prev_positions = [];
for section_id = holo_sections_id
    [~ , i_section] = getHoloSection(exp_id, section_id);
    holo_psth = holo_psths(i_section);
    holo_positions = holo_psth.psth.pattern_positions.mea;
    if ~isempty(prev_positions) && any(prev_positions(:) ~= holo_positions(:))
        error_struct.message = strcat("The holographic sessions chosen do not have the same patterns");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    prev_positions = holo_positions;
end

% STAs
[temporal, ~, ~, valid] = getSTAsComponents(exp_id, 'Label', label);
if all(valid ~= cell_id)
    warning(strcat('no valid STA defactorization found for cell #', num2str(cell_id)));
    return
end

% PSTHs max
if strcmp(mode, 'psth')
    visual_psth = sectionPSTHs(spikes(cell_id), visual_repetitions, rate, 'Time_Spacing', 0.2);
    visual_tbin = visual_psth.t_bin;
    visual_psth = cell2mat(visual_psth.responses)';
    max_psth = max(50, max(visual_psth(:)));
    
    for i_section = 1:numel(holo_sections_id)
        section_id = holo_sections_id(i_section);
        dh_psth = holo_psths(section_id).psth.responses(:, cell_id, :);
        max_dh_psth = max(dh_psth(:));
        if max_dh_psth > max_psth
            max_psth = max_dh_psth;
        end
    end
end

% Plot
n_columns = numel(holo_sections_id) + 2;
n_rows = 3;

figure();
subplot(n_rows, n_columns, [1, 2, n_columns+1, n_columns+2]);
plotHoloSTA(exp_id, cell_id, holo_sections_id(1), 'Label', label, 'Image', img_id, 'Is_Subfigure', true, 'Width_Microns', width, 'Center', center, 'Pattern_Colors', p_colors);
title('STA (spatial component)');

if ~isempty(color_map) && ~isempty(color_map_limits)
    colormap(color_map)
    hcb = colorbar;
    caxis(color_map_limits)
    title(hcb,'activation score')
end

subplot(n_rows, n_columns, 2*n_columns + 2)
plot(temporal(cell_id, :), "Color", 'b', "LineWidth", 2)
axis off
title('STA (temporal component)');

subplot(n_rows, n_columns, 2*n_columns + 1)
if strcmp(mode, 'raster')
    plotStimRaster(spikes{cell_id}, visual_repetitions.rep_begins, max([visual_repetitions.durations{:}]), rate, 'Labels', visual_repetitions.names);
else
    plotStimPSTH(visual_psth, visual_tbin, ...
        'Labels', visual_repetitions.names, ...
        'Stim_Onset_Seconds',   0.2, ...
        'Stim_Offset_Seconds', -0.2, ...
        'PSTH_max', max_psth);
end

title('Visual Responses)');

for i_section = 1:numel(holo_sections_id)
    section_id = holo_sections_id(i_section);
    subplot(1, n_columns, i_section + 2);
    multi_psth = holo_psths(section_id);
    
    if strcmp(mode, 'raster')
        repetitions = getHolographyRepetitions(exp_id, section_id);
        plotStimRaster(spikes{cell_id}, repetitions.rep_begins, median(repetitions.durations), rate, ...
            'Pattern_Indices', p_indices, ...
            'Raster_Colors', p_colors, ...
            'Edges_Onsets', multi_psth.resp_win(1), ...
            'Edges_Offsets', multi_psth.resp_win(2));
    else
        plotStimPSTH(multi_psth.psth.responses(:, cell_id, :), multi_psth.psth.t_bin, ...
            'Pattern_Indices', p_indices, ...
            'PSTH_Colors', p_colors, ...
            'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
            'Stim_Offset_Seconds', -multi_psth.psth.t_spacing, ...
            'Edges_Onsets', multi_psth.resp_win(1) +  multi_psth.psth.t_spacing, ...
            'Edges_Offsets', multi_psth.resp_win(2) +  multi_psth.psth.t_spacing, ...
            'PSTH_max', max_psth);
        
    end
    title(multi_psth.psth.name, 'Interpreter', 'None');
    
end
st = suptitle(strcat("Experiment ", exp_id, ", Cell#", num2str(cell_id)));
st.Interpreter = 'None';
fullScreen();
