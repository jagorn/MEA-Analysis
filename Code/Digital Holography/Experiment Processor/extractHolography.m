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
% raw_path (optional):              path to the raw file (by default it is the "sorted" folder in the experiment folder).
% raw_name (optional):              name of the raw file (by default it is the same as exp_id).

% Parameters Extraction
extract_triggers_def = true;
compute_repetitions_def = true;

% Parameters Raw Files
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Extract_Triggers', extract_triggers_def);
addParameter(p, 'Compute_Repetitions', compute_repetitions_def);
addParameter(p, 'Raw_Path', raw_path_def);
addParameter(p, 'Raw_Name', raw_name_def);

parse(p, exp_id, varargin{:});

extract_triggers = p.Results.Extract_Triggers;
extract_repetitions = p.Results.Compute_Repetitions;
raw_path = p.Results.Raw_Path; 
raw_name = p.Results.Raw_Name; 


% Folder Paths
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));

% Triggers
if extract_triggers
    fprintf('\n\nextracting holography triggers...\n\n')
    extractDHTimes(exp_id, raw_file, mea_rate);
end


% Initialize Holography
if ~isfile(stimHoloFile(exp_id)) 
    initializeExperimentHolo(exp_id)
    fprintf('The configuration file stims_holo.txt has been created.')
    fprintf('Fill the configuration file, and then run this function again.')
else
    
    % Initialize Table
    holography_table = generateHolographyTable(exp_id);
    
    % Repetitions
    if extract_repetitions

        fprintf('\n\ncomputing holography triggers...\n\n')
        dh_times = getDHTimes(exp_id);
        holography_table = assignStimTriggers(holography_table, dh_times);
        setHolographyTable(exp_id, holography_table);


        fprintf('\n\ncomputing holography repetitions...\n\n')
        holography_table = assignHolographyRepetitions(holography_table, exp_id);
        setHolographyTable(exp_id, holography_table);
    end

    % Test
    if extract_spikes && extract_repetitions
        fprintf('\n\nplots...\n\n')
        plotEulerCheckerTest(exp_id)
    end

end
  




