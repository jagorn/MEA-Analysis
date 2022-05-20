function evtTimes = extractEvtTimes(exp_id, raw_file, mea_rate, varargin)
% Extracts all the DMD event times from a raw file recordings.
% It groups the event times in "sections", and saves them in the experiment
% folder.

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addRequired(p, 'mea_rate');
addParameter(p, 'Inter_Section_DT', 8);
parse(p, raw_file, mea_rate, varargin{:});

inter_section_dt = p.Results.Inter_Section_DT; 

event_times_file = fullfile(processedPath(exp_id), 'EvtTimes.mat');
event_traces_file = fullfile(processedPath(exp_id), 'StimChannel_data.mat');

if isfile(event_times_file)
    load(event_times_file, 'evtTimes')
    disp("EvtTimes were already extracted. They will be loaded instead.")
else
    if isfile(event_traces_file)
        load(event_traces_file, 'stimChannel_data')
    else
        if ~isfile(raw_file)
            error_struct.message = strcat("Raw file ", raw_file, " does not exist.");
            error_struct.identifier = strcat('MEA_Analysis:', mfilename);
            error(error_struct);
        end
        stimChannel_data = extractDataDMD(raw_file);
        save(event_traces_file, 'stimChannel_data', '-v7.3');
    end
    evtTimes = detectEvents(stimChannel_data, mea_rate, ...
        'Session_Time_Separation', inter_section_dt, ...
        'Peak_Is_Positive', false, ...
        'Discard_Last_Event', true, ...
        'Generate_Missing_Triggers', true);
    
    fprintf('triggers extracted from %s\n', raw_file)
    save(event_times_file, 'evtTimes', 'mea_rate')
end