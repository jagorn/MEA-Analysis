function holographyPSTHs = getHolographyPSTHs(exp_id)
% Returns the psths to the holography stimuli for a given experiment
%
% PARAMETERS:
% EXP_ID:                               the identifier of the experiment.


holo_psth_file = fullfile(holoPath(exp_id), 'holographyPSTHs.mat');

try
    load(holo_psth_file, 'holographyPSTHs');
catch
    error_struct.message = strcat("holography PSTHs were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end

if ~exist('holographyPSTHs', 'var')
    error_struct.message = strcat("holography PSTHs were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
