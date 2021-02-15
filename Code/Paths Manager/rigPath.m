function path = rigPath()
path = fullfile(projectPath, 'Rig');

if ~isfolder(path)
    error_struct.message = strcat("the rig folder ",  path, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

