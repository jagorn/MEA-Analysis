function template = configTemplateDefault()
template = fullfile(projectPath, 'Stimuli', 'config_example.txt');

if ~isfile(template)
    error_struct.message = strcat("the configuration template ",  template, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
