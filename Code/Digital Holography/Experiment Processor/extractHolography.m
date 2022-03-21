function  extractHolography(exp_id, varargin)
% This function extracts and saves all the data related to holographic stimulation in an experiment:
% 1. Reads the holography configuration files inside the experiment folder.
% 2. Extracts the triggers for all the holographic sections.
% 3. Compute the repetitions of the repeated patterns for all the holographic sections
% 4. Saves all the above info in a table called HolographyTable.
%
% Parameters:
% 
% exp_ID:           the identifier of the experiment.
% extract_triggers (optional):      if true, it extracts and saves the experiment dh triggers.
% compute_repetitions (optional):   if true, it computes the repetitions of the dh patterns for each section.
% compute_psths (optional):   if true, it computes the psths for the dh patterns for each section.
% raw_path (optional):              path to the raw file (by default it is the "sorted" folder in the experiment folder).
% raw_name (optional):              name of the raw file (by default it is the same as exp_id).

% Parameters Extraction
extract_triggers_def = true;
compute_repetitions_def = true;
compute_psths_def = false;

% Parameters Raw Files
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;
mea_spacing_def = 30;

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Extract_Triggers', extract_triggers_def);
addParameter(p, 'Compute_Repetitions', compute_repetitions_def);
addParameter(p, 'Compute_PSTHs', compute_psths_def);
addParameter(p, 'Raw_Path', raw_path_def);
addParameter(p, 'Raw_Name', raw_name_def);
addParameter(p, 'MEA_Spacing', mea_spacing_def);

parse(p, exp_id, varargin{:});

extract_triggers = p.Results.Extract_Triggers;
extract_repetitions = p.Results.Compute_Repetitions;
compute_psths = p.Results.Compute_PSTHs;
raw_path = p.Results.Raw_Path; 
raw_name = p.Results.Raw_Name; 
mea_spacing = p.Results.MEA_Spacing; 

% Folder Paths
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));

% Triggers
if extract_triggers
    fprintf('\n\nextracting holography triggers...\n\n')
    mea_rate = getMeaRate(exp_id);
    extractDHTimes(exp_id, raw_file, mea_rate);
end

% Initialize Holography
if ~isfile(stimHoloFile(exp_id)) 
    initializeExperimentHolo(exp_id)
    fprintf('The configuration file stims_holo.txt has been created.\n')
    fprintf('Fill the configuration file, and then run this function again.\n')
else
    
    % Initialize Table
    holography_table = generateHolographyTable(exp_id);
    
    % Repetitions
    if extract_repetitions
        fprintf('\ncomputing holography triggers...\n');
        dh_times = getDHTimes(exp_id);
        holography_table = assignStimTriggers(holography_table, dh_times);
        setHolographyTable(exp_id, holography_table);

        fprintf('\ncomputing holography repetitions...\n');
        holography_table = assignHolographyRepetitions(holography_table, exp_id);
        setHolographyTable(exp_id, holography_table);
    end
    
    % Patterns
    addHoloPositions(exp_id);
    addHoloPictures(exp_id);
    
    if compute_psths
        fprintf('\ncomputing holography psths...\n')
        computeHolographyPSTHs(exp_id)
    end
end
