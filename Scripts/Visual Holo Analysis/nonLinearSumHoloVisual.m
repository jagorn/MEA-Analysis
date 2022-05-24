function [scores, activations, visual, holo] = nonLinearSumHoloVisual(exp_id, visual_section_id, dh_section_id, varargin)

p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'visual_section_id');
addRequired(p, 'dh_section_id');


addParameter(p, 'Visual_Window', [0.175 0.500]);
addParameter(p, 'Holo_Window', [0.000 0.500]);
addParameter(p, 'Visual_Pattern_Id', 1);
addParameter(p, 'Pattern_Idx', -1);
addParameter(p, 'Control_Window', [-0.300 0.000]);
addParameter(p, 'Activation_Window', []);
addParameter(p, 'Sigma', 5);
addParameter(p, 'Min_Fr', 10);
addParameter(p, 'Time_Bin', 0.05);

parse(p, exp_id, visual_section_id, dh_section_id,varargin{:});

visual_win = p.Results.Visual_Window;
holo_win = p.Results.Holo_Window;
visual_pattern_id = p.Results.Visual_Pattern_Id;
pattern_idx = p.Results.Pattern_Idx;

ctrl_win = p.Results.Control_Window;
act_win = p.Results.Activation_Window;
sigma = p.Results.Sigma;
min_fr = p.Results.Min_Fr;
time_bin = p.Results.Time_Bin;

% Holography
holo_psths_table = getHolographyPSTHs(exp_id);
holo_psth_section = holo_psths_table(dh_section_id);
[n_patterns, n_cells, n_bins] = size(holo_psth_section.psth.responses);
section_patterns = holo_psth_section.psth.patterns;


if pattern_idx == -1
    pattern_idx = 1:n_patterns;
end
% Visual
repetitions = getRepetitions(exp_id, visual_section_id);
spike_times = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);

% Holo
holo_repetitions = getHolographyRepetitions(exp_id, dh_section_id);
holo.psth = holo_psth_section.psth.responses;
holo.t = holo_psth_section.psth.time_sequences;
holo.win = holo_win;
holo.single_spot_patterns = cell(1, n_patterns);

holo_snippet_t =   holo.t(holo.t > act_win(1) & holo.t <= act_win(2));
holo.linear_sums = nan(n_patterns, n_cells, numel(holo_snippet_t));

visual_psth_section = sectionPSTHs(spike_times, repetitions, mea_rate, 'Time_Spacing' , holo_psth_section.psth.t_spacing + visual_win(1));
visual.psth = visual_psth_section.responses{visual_pattern_id};
visual.t = visual_psth_section.time_sequences{visual_pattern_id} + visual_win(1);
visual.win = visual_win;

disp('Psths computed');

if isempty(act_win)
    act_win = visual_win;
end

[zs, thresholds, scores, spontaneous_fr, latencies] = estimateZscoreBothSides(visual.psth, visual.t, time_bin, ctrl_win, act_win, sigma, min_fr);
activations.zs = zs;
activations.thresholds = thresholds;
activations.scores = scores;
activations.spontaneous_fr = spontaneous_fr;
activations.latencies = latencies;
activations.win = act_win;
disp('Activations computed');

scores = zeros(n_patterns, n_cells);
for i_cell = 1:n_cells
    for i_pattern = pattern_idx(:)' 
        spots = find(section_patterns(i_pattern, :));
        single_spot_patterns = filterHoloPatterns(holo_repetitions, ...
        "Optional_Spots", spots, ...
        "Allowed_N_Spots", 1, ...
        "N_Min_Repetitions", 5);
        if numel(spots) ~= numel(single_spot_patterns)
            if i_cell == 1
                warning(strcat('some spots did not have the right number of repetitions for pattern #', num2str(i_pattern)));
            end
            scores(i_pattern, i_cell) = nan;
            continue;
        end
            
        visual_snippet = visual.psth(:, visual.t > act_win(1) & visual.t <= act_win(2));     
        holo_snippet = holo.psth(:, :, holo.t > act_win(1) & holo.t <= act_win(2));
        holo.single_spot_patterns{i_pattern} = single_spot_patterns;
        
%         figure();
%         hold on;
%         area(holo_snippet_t, squeeze(holo_snippet(i_pattern, i_cell, :)), 'FaceColor', 'k', 'EdgeAlpha', 0, 'FaceAlpha', 0.3);
%         area(holo_snippet_t, visual_snippet(i_cell, :), 'FaceColor', 'r', 'EdgeAlpha', 0, 'FaceAlpha', 0.3)

        holo_linear_sum = zeros(size(visual_snippet(i_cell, :)));
        for single_spot_pattern = single_spot_patterns(:)'
            holo_snippet_single = squeeze(holo_snippet(single_spot_pattern, i_cell, :))';
            holo_difference_single = holo_snippet_single - visual_snippet(i_cell, :);
            holo_linear_sum = holo_linear_sum + holo_difference_single;
%             plot(holo_snippet_t, holo_snippet_single, 'k--')
            
        end
        holo_linear_sum = holo_linear_sum + visual_snippet(i_cell, :);
        holo_linear_sum(holo_linear_sum < 0) = 0;
%         area(holo_snippet_t, holo_linear_sum, 'FaceColor', 'b', 'EdgeAlpha', 0, 'FaceAlpha', 0.3)

        diff_act = max( holo_snippet(i_pattern, i_cell, :)) - max(holo_linear_sum);
        scores(i_pattern, i_cell) = diff_act;
        holo.linear_sums(i_pattern, i_cell, :) = holo_linear_sum;
    end
end
disp('non-linear summations computed');