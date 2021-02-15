function changeDataPath(location_name)

global mea_analysis_data_path
global mea_analysis_data_locations

if isempty(mea_analysis_data_locations)
    loadDataPaths();
end

if isKey(mea_analysis_data_locations, location_name)
    mea_analysis_data_path = mea_analysis_data_locations(location_name);
else
    error_struct.message = strcat("the data location ",  location_name, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end