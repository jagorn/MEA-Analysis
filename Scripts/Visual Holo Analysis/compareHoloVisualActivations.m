function [scores, activations, visual, holo] = compareHoloVisualActivations(exp_id, visual_section_id, dh_section_id, varargin)

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

if pattern_idx == -1
    pattern_idx = 1:n_patterns;
end
% Visual
repetitions = getRepetitions(exp_id, visual_section_id);
spike_times = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);

holo.psth = holo_psth_section.psth.responses;
holo.t = holo_psth_section.psth.time_sequences;
holo.win = holo_win;

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
activations.spontaneous_fr = spontaneous_fr;
activations.latencies = latencies;
activations.win = act_win;
disp('Activations computed');

scores = zeros(n_patterns, n_cells);
for i_cell = 1:n_cells
    for i_pattern = pattern_idx(:)'        
        visual_snippet = visual.psth(:, visual.t > act_win(1) & visual.t <= act_win(2));     
        holo_snippet = holo.psth(:, :, holo.t > act_win(1) & holo.t <= act_win(2));
        diff_act = max(visual_snippet(i_cell, :)) - max( holo_snippet(i_pattern, i_cell, :));
        scores(i_pattern, i_cell) = diff_act;
    end
end
