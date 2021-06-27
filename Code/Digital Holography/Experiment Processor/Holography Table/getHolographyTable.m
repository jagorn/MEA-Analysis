function holographyTable = getHolographyTable(exp_id)
% Returns the holography table of a given experiment
%
% PARAMETERS:
% EXP_ID:                               the identifier of the experiment.

% OUTPUT:
% A struct with an element for each holography section of the experiment, specifying stimulus played,
% conditions, triggers, repetitions, frame rate, etc...

stim_table_file = fullfile(holoPath(exp_id), 'HolographyTable.mat');

try
    load(stim_table_file, 'holographyTable');
catch
    error_struct.message = strcat("holographyTable was not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end

if ~exist('holographyTable', 'var')
    error_struct.message = strcat("holographyTable was not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
