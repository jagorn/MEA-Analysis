function path = stimPath(stim_name, create_if_not_exist)
path = fullfile(projectPath, 'Stimuli', stim_name);

if ~exist('create_if_not_exist', 'var')
    create_if_not_exist = false;
end

if ~isfolder(path) && create_if_not_exist
    fprintf("the stimulus folder %s does not exist and will be created\n\n", path);
    mkdir(path)
end
