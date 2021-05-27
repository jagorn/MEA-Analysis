function sections_table = generateHolographyTable(exp_id)
stim_file = stimHoloFile(exp_id);
sections_table = parseStimFile(stim_file);
setHolographyTable(exp_id, sections_table)
