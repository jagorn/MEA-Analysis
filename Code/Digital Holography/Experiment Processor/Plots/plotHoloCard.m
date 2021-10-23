function plotHoloCard(exp_id, cell_id, section_ids, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'section_ids');
addParameter(p, 'Label', "");
addParameter(p, 'Image', "X10");
addParameter(p, 'Mode', 'raster'); % raster or psth

parse(p, exp_id, cell_id, section_ids, varargin{:});
label = p.Results.Label;
img_id = p.Results.Image;
mode = p.Results.Mode;

holo_psths = getHolographyPSTHs(exp_id);

prev_positions = [];
for section_id = section_ids
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

[temporal, ~, ~, valid] = getSTAsComponents(exp_id, 'Label', label);
if all(valid ~= cell_id)
    warning(strcat('no valid STA defactorization found for cell #', num2str(cell_id)));
    return
end


rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);

n_columns = numel(section_ids) + 2;
n_rows = 3;

figure()
subplot(n_rows, n_columns, [1, 2, n_columns+1, n_columns+2])
plotHoloSTA(exp_id, cell_id, section_ids(1), 'Label', label, 'Image', img_id, 'Is_Subfigure', true);
title('STA (spatial component)');

subplot(n_rows, n_columns, 2*n_columns + 1)
plot(temporal(cell_id, :), "Color", 'b', "LineWidth", 2)
axis off
title('STA (temporal component)');

for i_section = 1:numel(section_ids)
    section_id = section_ids(i_section);
    subplot(1, n_columns, i_section + 2);
    multi_psth = holo_psths(section_id);
    
    if strcmp(mode, 'raster')
        repetitions = getHolographyRepetitions(exp_id, section_id);
        plotStimRaster(spikes{cell_id}, repetitions.rep_begins, median(repetitions.durations), rate, ...
            'Edges_Onsets', multi_psth.resp_win(1), ...
            'Edges_Offsets', multi_psth.resp_win(2));
    else
        plotStimPSTH(multi_psth.psth.responses(:, cell_id, :), multi_psth.psth.t_bin, ...
            'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
            'Stim_Offset_Seconds', -multi_psth.psth.t_spacing, ...
            'Edges_Onsets', multi_psth.resp_win(1) +  multi_psth.psth.t_spacing, ...
            'Edges_Offsets', multi_psth.resp_win(2) +  multi_psth.psth.t_spacings);
        
    end
    title(multi_psth.psth.name, 'Interpreter', 'None');
    
end
st = suptitle(strcat("Experiment ", exp_id, ", Cell#", num2str(cell_id)));
st.Interpreter = 'None';