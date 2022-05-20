function plotHoloPSTHsByCell(exp_id, dh_session_id, cell_id, varargin)


% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'dh_session_id');
addParameter(p, 'Mode', 'psth'); % raster or psth
addParameter(p, 'Patterns', []); % raster or psth
addParameter(p, 'PSTH_max', 20); % raster or psth

parse(p, exp_id, dh_session_id, varargin{:});
mode = p.Results.Mode;
patterns = p.Results.Patterns;
psth_max = p.Results.PSTH_max;

rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_session_id);
repetitions = getHolographyRepetitions(exp_id, dh_session_id);

if isempty(patterns)
    patterns = 1:numel(repetitions.durations);
end

if strcmp(mode, 'raster')
    plotStimRaster(spikes{cell_id}, repetitions.rep_begins(patterns), median(repetitions.durations(patterns)), rate, ...
                    'Edges_Onsets', multi_psth.resp_win(1), ...
                    'Edges_Offsets', multi_psth.resp_win(2), ...
                    'Post_Stim_DT', 0.5, ...
                    'Pre_Stim_DT', 0.5);
else
    plotStimPSTH(squeeze(multi_psth.psth.responses(patterns, cell_id, :)), multi_psth.psth.t_bin, ...
                    'PSTH_max', psth_max, ...
                    'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
                    'Stim_Offset_Seconds', -multi_psth.psth.t_spacing, ...
                    'Edges_Onsets', multi_psth.resp_win(1) +  multi_psth.psth.t_spacing, ...
                    'Edges_Offsets', multi_psth.resp_win(2) +  multi_psth.psth.t_spacing);
end

