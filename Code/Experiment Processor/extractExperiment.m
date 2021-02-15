function  extractExperiment(exp_id, mea_rate, varargin)

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
fprintf('\n\nplots...\n\n')
plotEulerCheckerTest(exp_id)
  




