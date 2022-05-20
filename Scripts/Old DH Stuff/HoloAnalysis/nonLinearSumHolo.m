function [scores, holo] = nonLinearSumHolo(exp_id, dh_section_id, varargin)

p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'dh_section_id');
addParameter(p, 'Pattern_Idx', -1);
addParameter(p, 'Cell_Idx', -1);

parse(p, exp_id, dh_section_id,varargin{:});
pattern_idx = p.Results.Pattern_Idx;
cell_idx = p.Results.Cell_Idx;

% Holography
holo_repetitions = getHolographyRepetitions(exp_id, dh_section_id);
holo_psths_table = getHolographyPSTHs(exp_id);
holo_psth_section = holo_psths_table(dh_section_id);
[n_patterns, n_cells, ~] = size(holo_psth_section.psth.responses);
section_patterns = holo_psth_section.psth.patterns;

if pattern_idx == -1
    pattern_idx = 1:n_patterns;
end
if cell_idx == -1
    cell_idx = 1:n_cells;
end


holo.psth = holo_psth_section.psth.responses;
holo.t = holo_psth_section.psth.time_sequences;
holo.win = holo_psth_section.resp_win;
holo.single_spot_patterns = cell(1, n_patterns);

holo_snippet_t =   holo.t(holo.t > holo_psth_section.resp_win(1) & holo.t <=  holo_psth_section.resp_win(2));
holo.linear_sums = nan(n_patterns, n_cells, numel(holo_snippet_t));

scores = nan(n_patterns, n_cells);
for i_cell = cell_idx
    for i_pattern = pattern_idx(:)' 
        spots = find(section_patterns(i_pattern, :));
        single_spot_patterns = filterHoloPatterns(holo_repetitions, ...
        "Optional_Spots", spots, ...
        "Allowed_N_Spots", 1, ...
        "N_Min_Repetitions", 5);
        if numel(spots) ~= numel(single_spot_patterns)
            continue;
        end
            
        holo_snippet = holo.psth(:, :, holo.t > holo_psth_section.resp_win(1) & holo.t <= holo_psth_section.resp_win(2));
        holo.single_spot_patterns{i_pattern} = single_spot_patterns;
        
%         figure();
%         hold on;

        holo_linear_sum = zeros(size(holo_snippet_t));
        for single_spot_pattern = single_spot_patterns(:)'
            holo_snippet_single = squeeze(holo_snippet(single_spot_pattern, i_cell, :))' - holo_psth_section.activations.baselines(single_spot_pattern, i_cell);
            holo_linear_sum = holo_linear_sum + holo_snippet_single;
%             plot(holo_snippet_t, holo_snippet_single, 'k--')
        end
        holo_linear_sum = holo_linear_sum + holo_psth_section.activations.baselines(single_spot_pattern, i_cell);
        holo_linear_sum(holo_linear_sum < 0) = 0;
        
%         area(holo_snippet_t, holo_linear_sum, 'FaceColor', 'b', 'EdgeAlpha', 0, 'FaceAlpha', 0.5)
%         area(holo_snippet_t, squeeze(holo_snippet(i_pattern, i_cell, :)), 'FaceColor', 'k', 'EdgeAlpha', 0, 'FaceAlpha', 0.5);
%         pause(2);
%         close all;

        diff_act = max( holo_snippet(i_pattern, i_cell, :)) - max(holo_linear_sum);
        scores(i_pattern, i_cell) = diff_act;
        holo.linear_sums(i_pattern, i_cell, :) = holo_linear_sum;
    end
end
disp('non-linear summations computed');
