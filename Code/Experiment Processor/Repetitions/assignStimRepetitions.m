function stimTable = assignStimRepetitions(stimTable, exp_id)
% Assigns to each section of the experiment the corresponding repetitions.
% All the repetitions are added as a new field 'repetitions' to the sections
% struct 'stimTable'.

% repetitions is struct describing the structure of the stimulus.
%   repetitions.names{i}:           the name of the i-th repeated patterns of the stimulus
%   repetitions.rep_begins{i}:      an array indicating the first trigger of each repetition of the i-th pattern
%   repetitions.durations{i}:       the duration (in frames) of the i-th pattern

for i_section = 1:numel(stimTable)
    section_id = stimTable(i_section).id;
    stim_id = stimTable(i_section).stimulus;
    triggers = stimTable(i_section).triggers;

	configs_file = configFile(exp_id, section_id);
	configs = parseConfigurationFile(configs_file);
    

    if ~isKey(configs, 'version')
        error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'stim_version' is missing");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    if ~isKey(configs, 'is_looping')
        error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'is_looping' is missing");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    stim_version = configs('version');
    is_looping = configs('is_looping');
    
    try
        repetition_indices = getRepetitionsMap(stim_id, stim_version);
    catch
        fprintf("\t%s : repetitions not available\n", section_id);
        continue
    end

    repetitions = computeRepetitions(triggers, repetition_indices, is_looping);
    stimTable(i_section).repetitions = repetitions;
    fprintf("\t%s : repetitions computed\n", section_id);
end