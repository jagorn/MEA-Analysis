function [activations, holo] = getHoloActivations(exp_id, dh_section_id)

% Holography
holo_psths_table = getHolographyPSTHs(exp_id);
holo_psth_section = holo_psths_table(dh_section_id);

% Visual
holo.psth = holo_psth_section.psth.responses;
holo.t = holo_psth_section.psth.time_sequences;
holo.win = holo_psth_section.resp_win;

activations.zs = holo_psth_section.activations.zs;
activations.thresholds = holo_psth_section.activations.thresholds;
activations.scores = holo_psth_section.activations.scores;
activations.spontaneous_fr = holo_psth_section.activations.baselines;
activations.latencies = holo_psth_section.activations.latencies;
activations.win = holo_psth_section.resp_win;


