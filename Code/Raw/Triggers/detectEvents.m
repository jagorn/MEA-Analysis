function events = detectEvents(raw_trace, mea_rate, varargin)
% Detects events trepassing a threshold in a given  raw trace
% Contiguous events are grouped together in sessions
% INPUTS:
% raw_trace: the raw trace
% mea_rate: the sampling rate of the trace  (hz)
% peak_is_positive (optional): true if the peaks representing events are positive, false if they are negative
% sessions_time_separation (optional): the max time interval between two events belonging to the same session (seconds)
% discard_last_event (optional): if true, the last event of each session is discarded
% generate_missing_events (optional): if true, missing events are generated
% OUTPUT:
% events: a cell array (one per events session) specifying
%         start and end of each event

% Parameters
sessions_time_separation_def = 5;
peak_is_positive_def = true;
discard_last_event_def = false;
generate_missing_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'raw_trace');
addRequired(p, 'mea_rate');
addParameter(p, 'Session_Time_Separation', sessions_time_separation_def);
addParameter(p, 'Peak_Is_Positive', peak_is_positive_def);
addParameter(p, 'Discard_Last_Event', discard_last_event_def);
addParameter(p, 'Generate_Missing_Triggers', generate_missing_def);

parse(p, raw_trace, mea_rate, varargin{:});

sessions_time_separation = p.Results.Session_Time_Separation;
peak_is_positive = p.Results.Peak_Is_Positive;
discard_last_event = p.Results.Discard_Last_Event;
generate_missing = p.Results.Generate_Missing_Triggers;

% normalize the trace
base =  median(raw_trace);
base_trace = (raw_trace - base);

% put event peaks upwards
if ~peak_is_positive
    base_trace = -base_trace;
end

% Detect events
detection_threshold = max(base_trace) * 0.15;
detection_peak = max(base_trace) * 0.20;

EvtTime_init = find(base_trace(1:end-1)<detection_threshold & base_trace(2:end) >= detection_threshold )+1;
EvtTime_end = find(base_trace(1:end-1)>detection_threshold & base_trace(2:end)<=detection_threshold )+1;

% Discard the first or last event if they are at the end or at the beginning of the recording
if EvtTime_init(end) > EvtTime_end(end)
    EvtTime_init = EvtTime_init(1:end-1);
end
if EvtTime_end(1) < EvtTime_init(1)
    EvtTime_end = EvtTime_end(2:end);
end

% Discard the events that are too small (false positives)
false_positives = [];
for i_event = 1:numel(EvtTime_init)
    if max(base_trace(EvtTime_init(i_event):EvtTime_end(i_event))) < detection_peak
        false_positives = [false_positives, i_event];
    end
end
EvtTime_init(false_positives) = [];
EvtTime_end(false_positives) = [];

% compute the time intervals
EvtIntervals = diff(EvtTime_init)/mea_rate;
DiscontinuityIndices = find(EvtIntervals > sessions_time_separation);

StimBegin_Indices = [1, DiscontinuityIndices + 1];
StimEnd_Indices = [DiscontinuityIndices, numel(EvtTime_init)];

% Split the events in sessions
events = {};
for i_stim = 1:length(StimBegin_Indices)
    events_begin = EvtTime_init(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    events_end =  EvtTime_end(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    
    median_period = median(diff(events_begin));
    median_event_dt = median(events_end - events_begin);
    
    % Discard the last event of the session
    if discard_last_event
        events_begin = events_begin(1:end-1);
        events_end = events_end(1:end-1);
    end
    
    % Generate missing triggers
    if generate_missing
        
        all_missing_events_begin = [];
        all_missing_events_end = [];
        intervals = diff(events_begin);
        
        for i_interval = 1:numel(intervals)
            n_intervals = intervals(i_interval) /  median_period;
            res_intervals = mod(intervals(i_interval), median_period);
            rest_down = median_period*0.99;
            rest_up = median_period*0.01;
            
            if n_intervals > 1.5
                fprintf('warning: some events seem to be missing in the session %i.\n', i_stim);
                if res_intervals > rest_down || res_intervals < rest_up
                    evt_begin_missing = events_begin(i_interval);
                    
                    missing_intervals = round(n_intervals) - 1;
                    for i_missing = 1:missing_intervals
                        evt_begin_missing = evt_begin_missing + median_period;
                        evt_end_missing = evt_begin_missing + median_event_dt;
                        
                        all_missing_events_begin = [all_missing_events_begin evt_begin_missing];
                        all_missing_events_end = [all_missing_events_end evt_end_missing];
                    end
                    
                    fprintf('%i missing events have been generated.\n\n', missing_intervals);
                else
                    fprintf('events are too noisy: not possible to regenerate missing events.\n\n');
                end
                
            end
        end
        
        % Add missing events
        events_begin = sort([events_begin all_missing_events_begin]);
        events_end = sort([events_end all_missing_events_end]);
    end
    
    events{i_stim}.evtTimes_begin = events_begin;
    events{i_stim}.evtTimes_end = events_end;
    events{i_stim}.evtTimes_hz = round(mea_rate/median_period * 100) / 100;
end

% save everything
fprintf('%i event sessions found:\n', numel(events));
for i_evt = 1:numel(events)
    evt_rate = events{i_evt}.evtTimes_hz;
    evt_intervals = diff(events{i_evt}.evtTimes_begin);
    evt_time_dev = round(max(abs(median(evt_intervals) - evt_intervals)));
    fprintf('\t%i: rate = %i Hz,\t\t n_events = %i,\t\t max_timestep_deviation = %i\n', i_evt, evt_rate, numel(events{i_evt}.evtTimes_begin), evt_time_dev);
end
fprintf('\n\n')
