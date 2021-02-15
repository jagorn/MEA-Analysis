function psth_pattern = getDefaultPattern()
% return the label of the default PSTH.
% the default PSTH is the PSTH that is shown in all the plots and cards.
% it can be changed using the method "changeDefaultPattern

global default_psth_pattern

if isempty(default_psth_pattern)
    psths_list = getPsthsList();
    default_psth_pattern = psths_list{1};
end
psth_pattern = default_psth_pattern;


