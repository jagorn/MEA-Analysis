function sections_table = generateSectionsTable(exp_id)
stim_file = stimFile(exp_id);
sections_table = parseStimFile(stim_file);
setSectionsTable(exp_id, sections_table)
