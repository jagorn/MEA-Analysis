function path = homographiesPath()
path = fullfile(projectPath, 'Homographies');

if ~isfolder(path)
    error_struct.message = strcat("the homographies folder ",  path, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
