function stimTable = assignStimRepetitions(stimTable, exp_id)

for i_section = 1:numel(stimTable)
    section_id = stimTable(i_section).id;
    stim_id = stimTable(i_section).stimulus;
    triggers = stimTable(i_section).triggers;

	configs_file = configFile(exp_id, section_id);
	configs = parseConfigurationFile(configs_file);
    

    if ~isKey(configs, 'stim_version')
        error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'stim_version' is missing");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    if ~isKey(configs, 'is_looping')
        error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'is_looping' is missing");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    stim_version = configs('stim_version');
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