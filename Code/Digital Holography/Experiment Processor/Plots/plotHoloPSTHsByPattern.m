function plotHoloPSTHsByPattern(exp_id, dh_session_id, pattern, cell_ids, varargin)


% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'dh_session_id');
addParameter(p, 'Set_Types', ["test", "train"]);
addParameter(p, 'Mode', 'psth'); % raster or psth

parse(p, exp_id, dh_session_id, varargin{:});
mode = p.Results.Mode;

rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_session_id);
repetitions = getHolographyRepetitions(exp_id, dh_session_id);


if strcmp(mode, 'raster')
    plotCellsRaster(spikes, repetitions.rep_begins{pattern}, repetitions.durations(pattern), rate, ...
                    'Cells_Indices', cell_ids, ...
                    'Edges_Onsets', multi_psth.resp_win(1), ...
                    'Edges_Offsets', multi_psth.resp_win(2), ...
                    'Post_Stim_DT', 0.2, ...
                    'Pre_Stim_DT', 0.2);
else
    plotStimPSTH(squeeze(multi_psth.psth.responses(pattern, :, :)), multi_psth.psth.t_bin, ...
                    'Pattern_Indices', cell_ids, ...
                    'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
                    'Stim_Offset_Seconds', -multi_psth.psth.t_spacing, ...
                    'Edges_Onsets', multi_psth.resp_win(1) +  multi_psth.psth.t_spacing, ...
                    'Edges_Offsets', multi_psth.resp_win(2) +  multi_psth.psth.t_spacing);
end

