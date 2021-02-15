function initializeExperiment(exp_id)
exp_id = char(exp_id);

% create the experiment folder
exp_folder = expPath(exp_id);
if isfolder(exp_folder)
    error_struct.message = strcat("the experiment ",  exp_id, " already exists");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
mkdir(exp_folder);

% create all the subfolders
sorted_folder = sortedPath(exp_id);
mkdir(sorted_folder);

processed_folder = processedPath(exp_id);
mkdir(processed_folder);

% create the stims_order.txt file
stims_file = fullfile(rigPath(), 'stims_example.txt');
copyfile(stims_file, stimFile(exp_id))

% copy the rig configuration files
probe_file = fullfile(rigPath(), 'mea_256.prb');
copyfile(probe_file, probeFile(exp_id))

mea_map_file = fullfile(rigPath(), 'PositionsMEA.mat');
copyfile(mea_map_file, meaFile(exp_id))


fprintf('\nThe experiment ''%s'' has been initialized!\n\n', exp_id);
fprintf('Please compile the file ''%s''.\n', stimFile(exp_id));
fprintf('You may add your raw files and the results of the spike-sorting here:\n''%s''\n', sorted_folder);
fprintf('\n');

