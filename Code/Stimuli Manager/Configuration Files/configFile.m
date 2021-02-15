function config_file = configFile(exp_id, stim_id)
config_file = fullfile(sectionPath(exp_id, stim_id), 'config.txt');
