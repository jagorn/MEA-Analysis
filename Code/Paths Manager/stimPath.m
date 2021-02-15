function path = stimPath(stim_name)
path = fullfile(projectPath, 'Stimuli', stim_name);

if ~isfolder(path)
    fprintf("the stimulus folder %s does not exist and will be created\n\n", path);
    mkdir(path)
end
