function changeDefaultPattern(psth_pattern, psth_label)
% changes the default PSTH.
% the default PSTH is the PSTH that is shown in all the plots and cards.

% INPUTS
% psth_pattern: the label of the new default psth.


global default_psth_pattern

load(getDatasetMat(), 'psths');
if ~exist('psths', 'var') || ~isfield(psths, psth_pattern) || ~isfield(psths.(psth_pattern), psth_label)
    error_struct.message = strcat("There is no psth ", psth_label, " for pattern ", psth_pattern, " in this dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

default_psth_pattern = {psth_pattern, psth_label};


