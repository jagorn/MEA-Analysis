function path = datasetsPath()
path = fullfile(projectPath, 'Datasets');

if ~isfolder(path)
    error_struct.message = strcat("the dataset folder ",  path, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

