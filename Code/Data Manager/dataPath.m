function path = dataPath()
global mea_analysis_data_path

if isempty(mea_analysis_data_path)
    loadDataPaths()
end
path = mea_analysis_data_path;

if ~isfolder(path)
    error_struct.message = strcat("the data folder ",  path, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end