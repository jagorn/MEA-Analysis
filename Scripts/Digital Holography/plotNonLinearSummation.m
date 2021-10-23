function plotNonLinearSummation(exp_id, holo_section_id, cell_id, spot_ids)

repetitions = getHolographyRepetitions(exp_id, holo_section_id);
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(holo_section_id);
pattern_ids = zeros(1, numel(spot_ids));
for i_spot = 1:numel(spot_ids)
    pattern_ids(i_spot) = filterHoloPatterns(repetitions, 'Allowed_N_Spots', 1, 'Optional_Spots', spot_ids(i_spot));
end

multi_pattern_id = filterHoloPatterns(repetitions, 'Allowed_N_Spots', numel(spot_ids), 'Mandatory_Spots', spot_ids, 'Optional_Spots', []);


figure();
hold on



y_psth = squeeze(multi_psth.psth.responses(multi_pattern_id, cell_id, :))';  
x_psth = multi_psth.psth.time_sequences;
y_base = zeros(size(y_psth));

x_between = [x_psth, fliplr(x_psth)];
in_between = [y_psth, fliplr(y_base)];
fill(x_between, in_between, 'r', 'EdgeColor', 'r');

single_psths = squeeze(multi_psth.psth.responses(pattern_ids, cell_id, :))';
plot(x_psth, single_psths, 'k--', 'LineWidth', 1);
