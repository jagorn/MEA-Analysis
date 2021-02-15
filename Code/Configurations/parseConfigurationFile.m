function config_map = parseConfigurationFile(stim_file)

if ~isfile(stim_file)
    error_struct.message = strcat(stim_file, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fid = fopen(stim_file,'r');
entry = fgetl(fid);
stim_entries = cell(0,1);
while ischar(entry)
    stim_entries{end+1,1} = entry;
    entry = fgetl(fid);
end
fclose(fid);


config_map = containers.Map;
try
    for i_entry = 1:numel(stim_entries)
        stim_line = stim_entries{i_entry};
        
        % exclude comments from config_lines
        if isempty(stim_line) || stim_line(1) == '#'
            continue;
        end
        
        % isolate infos and comments
        start_comment = regexp(stim_line, '#', 'once');
        if isempty(start_comment)
            infos = stim_line;
        else
            infos = stim_line(1 : start_comment-1);
        end
        
        % isolate parameter's name and value
        infos = regexprep(infos, '[ |\t]+', '');
        infos_split = lower(regexp(infos, '=','split'));
        parameter_name = infos_split{1};
        parameter_value = infos_split{2};
        config_map(parameter_name) = parameter_value;
    end
    
catch
    error_struct.message = strcat(stim_file, " is badly formatted");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

