function PatternImage = getHolographyPositionsImg(exp_id, stim_id)

stim_file = fullfile(holoPath(exp_id), strcat(stim_id, '.mat'));
if ~isfile(stim_file)
    error_struct.message = strcat("Holography frames file ", stim_file, " not found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

load(stim_file, 'PatternImage')
if ~exist('PatternImage', 'var')
    error_struct.message = strcat("Holography frames file ", stim_file, " is corrupted or incomplete");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
