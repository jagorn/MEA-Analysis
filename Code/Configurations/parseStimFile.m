function stim_table = parseStimFile(stim_file)

if ~isfile(stim_file)
    error_struct.message = strcat(stim_file, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% TODO: fix this
stim_entries = importdata(stim_file);
stim_table = {};
stim_count = 1;

try
    for i_entry = 1:numel(stim_entries)
        stim_line = stim_entries{i_entry};
        
        % exclude comments from config_lines
        if stim_line(1) == '#'
            continue;
        end
        
        % isolate infos and comments
        start_comment = regexp(stim_line, '#', 'once');
        if isempty(start_comment)
            comment = '';
            infos = stim_line;
        else
            infos = stim_line(1 : start_comment-1);
            comment = stim_line(start_comment+1 : end);
        end
        
        % isolate stim and conditions
        start_conditions = regexp(infos, '(');
        end_conditions = regexp(infos, ')');

        if isempty(start_conditions)
            stim = regexprep(infos, '[ |\t]+', '');
            stim = lower(stim);
            conditions = [];
        else
            begin_condition_index = start_conditions(1);
            end_condition_index = end_conditions(end);
            
            stim = infos(1:begin_condition_index-1);
            stim = regexprep(stim, '[ |\t]+', '');
            stim = lower(stim);
            
            conditions_raw = infos(begin_condition_index+1:end_condition_index-1);
            conditions = regexp(conditions_raw, ',','split');
            for i_condition = 1:numel(conditions)
                conditions{i_condition} = lower(regexprep(conditions{i_condition}, '[ |\t]+', ''));
            end
        end
        
        stim_id = strcat(num2str(stim_count), '-', stim);
        if ~isempty(conditions)
            stim_id = strcat(stim_id, '_(', join(string(conditions), '_'), ')');
        end
        
        stim_table(stim_count).id = stim_id;
        stim_table(stim_count).stimulus = string(stim);
        stim_table(stim_count).conditions = string(conditions);
        stim_table(stim_count).notes = string(comment);
        stim_count = stim_count + 1;
       
    end
    
catch
   error_struct.message = "stims.txt file is badly formatted";
   error_struct.identifier = strcat('MEA_Analysis:', mfilename);
   error(error_struct);
end

