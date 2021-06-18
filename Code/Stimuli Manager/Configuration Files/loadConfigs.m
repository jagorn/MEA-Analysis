function configs = loadConfigs(exp_id, section_id)

configs_file = configFile(exp_id, section_id);
configs = parseConfigurationFile(configs_file);