
% My Parameters
exp_id = 'my_experiment';    % the name of the experiment
mea_rate = 20000;     % the recordings sampling rate


% first, we initialize the experiment.
initializeExperiment(exp_id);

% this will create in the data path a folder named after the experiment.
% Inside, you'll find:
% - processed folder: the library saves here the processed data.
% - sorted folder: the library looks here for raw and spike-sorted files.

% before moving to the next step, fill the stim.txt file
% to tell the library which stimuli you played during the experiment

% we are now ready to initialize the experiment sections:
initializeSections(exp_id);

% this will create a folder for each section of the experiment.
% go through all of the section folders, and check the config.txt files.
% Make sure all the parameters are correct.


% finally, we can extract the data!

% you can specify the path to the raw file...
raw_path = '/my/path/example';
raw_name = 'my_raw_file';

% ... and the path to the spike-sorted files.
sorting_path = '/my/path/example';
sorting_name = 'my_spike_sorting_results';
sorting_suf = '-my_spike_sorting_savings';

% and extract the data.
extractExperiment(exp_id, mea_rate, 'Raw_Path', raw_path, ...
                                  'Raw_Name', raw_name, ...
                                  'Sorting_Path', sorting_path, ...
                                  'Sorting_Name', sorting_name, ...
                                  'Sorting_Suffix', sorting_suf);

% this will extract all the event marker for the stimuli,
% assign them to our sections, and also compute the repetitions
% for the repeated portions of the stimuli.

% We can now visualize our plots
section_id = '3-flicker';  % name of the section to plot.
cell_idx = [2, 10, 13];  % indexes of the cells to plot.
plotSectionPsth(exp_id, section_id, 'CellIndices', cell_idx)



% Compute the Spike-Triggered Average
computeSTAs(exp_id);

% and plot the spatial and temporal defactorized components:
cell_id = 1;
plotExpSTA('TEST', 1)
