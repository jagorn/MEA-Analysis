function loadDataPaths()
global mea_analysis_data_path
global mea_analysis_data_locations

% load the configuration file
configuration_path = fullfile(projectPath(), 'data_path_configuration.txt');
configuration_entries = importdata(configuration_path);

% initialize the data locations map
mea_analysis_data_locations = containers.Map;

for i = 1:numel(configuration_entries)
    config_line = configuration_entries{i};
    
    % exclude comments from config_lines
    if config_line(1) == '#'
        continue;
    end
    
    % isolate location name and path from the entry
    entries = regexp(config_line, '=','split');
    location_name_entry = entries{1};
    location_path_entry = entries{2};
    
    % remove spaces from the location name
    location_name = regexprep(location_name_entry, '[ |\t]+', '');
    
    % isolate the location path
    location_path_entry_splitted = regexp(location_path_entry, '''', 'split');
    location_path = location_path_entry_splitted{2};
    
    % add the location to the map
    mea_analysis_data_locations(location_name) = location_path;
    
    % if the data path is empty, initialize it with the first locatin entry
    if isempty(mea_analysis_data_path)
        mea_analysis_data_path = location_path;
    end
end


if isempty(mea_analysis_data_path)
    error_struct.message = "the data path configuration file is empty or badly formatted";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end