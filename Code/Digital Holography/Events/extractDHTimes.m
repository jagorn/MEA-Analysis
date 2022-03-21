function dhTimes = extractDHTimes(exp_id, raw_file, mea_rate, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addRequired(p, 'mea_rate');
addParameter(p, 'Inter_Section_DT', 20);
parse(p, raw_file, mea_rate, varargin{:});

inter_section_dt = p.Results.Inter_Section_DT; 

dh_times_file = fullfile(processedPath(exp_id), 'DHTimes.mat');
dh_traces_file = fullfile(processedPath(exp_id), 'DHChannel_data.mat');

if isfile(dh_times_file)
    load(dh_times_file, 'dhTimes')
    disp("dhTimes were already extracted. They will be loaded instead.")
else
    if isfile(dh_traces_file)
        load(dh_traces_file, 'DHChannel_data')
    else
        if ~isfile(raw_file)
            error_struct.message = strcat("Raw file ", raw_file, " does not exist.");
            error_struct.identifier = strcat('MEA_Analysis:', mfilename);
            error(error_struct);
        end
        DHChannel_data = extractDataDH(raw_file);
        save(dh_traces_file, 'DHChannel_data', '-v7.3');
    end
    dhTimes = detectEvents(DHChannel_data, mea_rate, ...
        'Session_Time_Separation', inter_section_dt, ...
        'Peak_Is_Positive', true, ...
        'Discard_Last_Event', false, ...
        'Generate_Missing_Triggers', false);
    
    fprintf('dh triggers extracted from %s\n', raw_file)
    save(dh_times_file, 'dhTimes', 'mea_rate')
end