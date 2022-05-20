function visual_minus_holo_score = compareHoloVisualActivations_OLD() % exp_id, visual_section_id, dh_section_id) ctrl_win, resp_win, k, min_fr)

onset_dh_visual = 0.150; % seconds
offset_dh_visual = 0.350; % seconds

visual_pattern_id = 1;

exp_id = '20210517_a2';
visual_section_id = 4; % DiscDelay
dh_section_id = 4; % Holo White Disc

% Holography
psths = getHolographyPSTHs(exp_id);
holo_psth = psths(dh_section_id);
[n_patterns, n_cells, n_bins] = size(holo_psth.psth.responses);

% Visual
repetitions = getRepetitions(exp_id, visual_section_id);
spike_times = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);

holo_t = holo_psth.psth.time_sequences;
psth_indices = (holo_t> onset_dh_visual& holo_t<= offset_dh_visual);
visual_psth = sectionPSTHs(spike_times, repetitions, mea_rate, 'Time_Spacing' , holo_psth.psth.t_spacing + onset_dh_visual);

visual_snippets = visual_psth.responses{visual_pattern_id}(:, psth_indices);
holo_snippets = squeeze(holo_psth.psth.responses(:, :, psth_indices));

visual_minus_holo_score = zeros(n_cells, n_patterns);
for i_cell = 1:n_cells
    for i_pattern = 1:n_patterns
        
        score = max(visual_snippets(i_cell, :)) - max( holo_snippets(i_pattern, i_cell, :)); 
        visual_minus_holo_score(i_cell, i_pattern) = score;
% 
%                     hold off
%                     plot(holo_t(psth_indices), visual_snippets(i_cell, :), 'LineWidth', 3)
%                     hold on
%                     plot(holo_t(psth_indices), squeeze(holo_snippets(i_pattern, i_cell, :)), 'LineWidth', 3)
%                     xlabel('time (s)')
%                     ylabel('firing rate (hz)');
%                     legend({'Visual', 'Visual & Inhibition'})
%         
%         waitforbuttonpress();
        
    end
end
