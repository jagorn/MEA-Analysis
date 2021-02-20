function initializeSections(exp_id)
% Initialize the sections of an experiment.
% For each section, it creates a folder and a configuration file to compile.
%
% PARAMETERS:
%
% EXP_ID: the identifier (string) of the experiment



sections_table = generateSectionsTable(exp_id);

for i_section = 1:numel(sections_table)
    
    stim_id = sections_table(i_section).stimulus;
    section_id = sections_table(i_section).id;
    section_folder = sectionPath(exp_id, section_id);
    
    % create section folder
    if ~isfolder(section_folder)
        mkdir(section_folder);
    end
    
    % add section config.txt
    try
        config_template_file = configTemplateSection(stim_id);
    catch
        config_template_file =  configTemplateDefault();
    end
    copyfile(config_template_file, configFile(exp_id, section_id))
end


fprintf('\nThe sections for the experiment ''%s'' have been initialized!\n', exp_id);
fprintf('Please compile the configuration files for each section.\n');
fprintf('\n');
