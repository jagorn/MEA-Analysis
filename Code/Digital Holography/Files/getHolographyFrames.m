function [TotalBlock, BlockSign] = getHolographyFrames(exp_id, stim_id)

stim_file = fullfile(holoPath(exp_id), strcat(stim_id, '.mat'));
if ~isfile(stim_file)
    error_struct.message = strcat("Holography frames file ", stim_file, " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

load(stim_file, 'TotalBlock', 'BlockSign')
if ~exist('TotalBlock', 'var') || ~exist('BlockSign', 'var') 
    error_struct.message = strcat("Holography frames file ", stim_file, " is corrupted or incomplete");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
