function  extractExperiment(exp_id, mea_rate, varargin)
% This function extracts and saves all the data related to an experiment:
% 1. Reads all the configuration files inside the secition folders.
% 2. Extracts the triggers for all the experiment sections.
% 3. Compute the repetitions of the repeated patterns for all the experiment sections
% 4. Saves all the above info in a table called SectionsTable.
% 5. Extracts and saves the spike times and tags for all the experiment cells.
%
% Parameters:
% 
% exp_ID:           the identifier of the experiment.
% mea_rate:         the sampling rate of the experiment recordings.
% extract_triggers (optional):      if true, it extracts and saves the experiment triggers.
% compute_repetitions (optional):   if true, it computes the repetitions of the reapeated patterns for each section.
% extract_multiunit (optional):     if true, it extracts and saves the multiunit spike times obtained with the thresholding function of spiking-circus.
% extract_sortedSpikes (optional):  if true, it extracts and saves the sorted spike times obtained with the sorting function of spiking-circus.
% extract_tags (optional):          if true, it extracts and saves the cell tags from the spiking-circus results file
% raw_path (optional):              path to the raw file (by default it is the "sorted" folder in the experiment folder).
% raw_name (optional):              name of the raw file (by default it is the same as exp_id).
% sorting_path (optional):          path to the sorting results (by default it is the "sorted" folder in the experiment folder.
% sorting_name (optional):          name of the sorting results files (by default it is the same as exp_id).
% sorting_suffix (optional):        the version of the sorting results to be used.

% Parameters Extraction
extract_triggers_def = true;
compute_repetitions_def = true;
extract_multiunit_def = false;
extract_spikes_def = true;
extract_tags_def = true;

% Parameters Raw Files
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;

% Parameters Sorting Files
sorting_path_def = sortedPath(exp_id);
sorting_name_def = exp_id;
sorting_results_suffix_def = '-final';

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Extract_Triggers', extract_triggers_def);
addParameter(p, 'Compute_Repetitions', compute_repetitions_def);
addParameter(p, 'Extract_MultiUnit', extract_multiunit_def);
addParameter(p, 'Extract_SortedSpikes', extract_spikes_def);
addParameter(p, 'Extract_Tags', extract_tags_def);
addParameter(p, 'Raw_Path', raw_path_def);
addParameter(p, 'Raw_Name', raw_name_def);
addParameter(p, 'Sorting_Path', sorting_path_def);
addParameter(p, 'Sorting_Name', sorting_name_def);
addParameter(p, 'Sorting_Suffix', sorting_results_suffix_def);

parse(p, exp_id, varargin{:});

extract_triggers = p.Results.Extract_Triggers;
extract_repetitions = p.Results.Compute_Repetitions;
extract_multiunit = p.Results.Extract_MultiUnit; 
extract_spikes = p.Results.Extract_SortedSpikes; 
extract_tags = p.Results.Extract_Tags; 

raw_path = p.Results.Raw_Path; 
raw_name = p.Results.Raw_Name; 

sorting_path = p.Results.Sorting_Path; 
sorting_name = p.Results.Sorting_Name; 
sorting_suffix = p.Results.Sorting_Suffix; 


% Folder Paths
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));
spikes_file = fullfile(sorting_path, sorting_name, strcat(sorting_name, '.result', sorting_suffix, '.hdf5'));
tags_file = fullfile(sorting_path, sorting_name, strcat(sorting_name, '.templates', sorting_suffix, '.hdf5'));
mua_file = fullfile(sorting_path, sorting_name, strcat(sorting_name, '.mua.hdf5'));


% Triggers
if extract_triggers
    fprintf('\n\nextracting triggers...\n\n')
    evt_times = extractEvtTimes(exp_id, raw_file, mea_rate);
    
    sections_table = getSectionsTable(exp_id);
    sections_table = assignStimTriggers(sections_table, evt_times);
    setSectionsTable(exp_id, sections_table);
end


% Repetitions
if extract_repetitions
    fprintf('\n\ncomputing repetitions...\n\n')
    sections_table = getSectionsTable(exp_id);
    sections_table = assignStimRepetitions(sections_table, exp_id);
    setSectionsTable(exp_id, sections_table);
    
    fprintf('\n\nsaving repetitions...\n\n')
    saveRepetitions(exp_id);
end


% Spike Times
if extract_multiunit
    fprintf('\n\nextracting multi unit responses...\n\n')
    extractMultiUnitResponses(exp_id, mua_file);
end

if extract_spikes
    fprintf('\n\nextracting sorted responses...\n\n')
    extractCellResponses(exp_id, spikes_file);
end

if extract_tags
    fprintf('\n\nextracting cell tags...\n\n')
    extractCellTags(exp_id, tags_file);
end

% Test
if extract_spikes && extract_repetitions
    fprintf('\n\nplots...\n\n')
    plotEulerCheckerTest(exp_id)
end
  




