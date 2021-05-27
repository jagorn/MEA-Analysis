function initializeExperimentHolo(exp_id)
% Creates the Holography folder for an experiment
% and initializes the stimulus file stims_holo.txt
%
% PARAMETERS:
%
% EXP_ID: the identifier (string) of the experiment

exp_id = char(exp_id);

% find the experiment folder
exp_folder = expPath(exp_id);
processed_folder = processedPath(exp_id);

if ~isfolder(exp_folder) || ~isfolder(processed_folder)
    error_struct.message = strcat("the experiment ",  exp_id, " has not been initialized");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% create the holography subfolders
holo_folder = holoPath(exp_id);

if ~isfolder(holo_folder)
    mkdir(holo_folder);
end

% create the stims_order.txt file
if ~isfile(stimHoloFile(exp_id))
    stims_file = fullfile(rigPath(), 'stims_holo_example.txt');
    copyfile(stims_file, stimHoloFile(exp_id))
end

fprintf('\nThe holography folder for experiment ''%s'' has been initialized!\n\n', exp_id);
fprintf('Please compile the file ''%s''.\n', stimHoloFile(exp_id));
fprintf('You may add your holography frame files (dh_frames):\n''%s''\n', holo_folder);
fprintf('\n');

