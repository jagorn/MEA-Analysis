function events = detectEvents(raw_trace, mea_rate, varargin)
% Detects events trepassing a threshold in a given  raw trace
% Contiguous events are grouped together in sessions 
% INPUTS:
% raw_trace: the raw trace
% mea_rate: the sampling rate of the trace  (hz)
% peak_is_positive (optional): true if the peaks representing events are positive, false if they are negative
% sessions_time_separation (optional): the max time interval between two events belonging to the same session (seconds)
% discard_last_event (optional): if true, the last event of each session is discarded
%
% OUTPUT:
% events: a cell array (one per events session) specifying 
%         start and end of each event

% Parameters
sessions_time_separation_def = 5;
peak_is_positive_def = true;
discard_last_event_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'raw_trace');
addRequired(p, 'mea_rate');
addParameter(p, 'Session_Time_Separation', sessions_time_separation_def);
addParameter(p, 'Peak_Is_Positive', peak_is_positive_def);
addParameter(p, 'Discard_Last_Event', discard_last_event_def);

parse(p, raw_trace, mea_rate, varargin{:});

sessions_time_separation = p.Results.Session_Time_Separation;
peak_is_positive = p.Results.Peak_Is_Positive;
discard_last_event = p.Results.Discard_Last_Event; 


base =  median(raw_trace);
base_trace = (raw_trace - base);

if ~peak_is_positive
    base_trace = -base_trace;
end

detection_threshold = max(base_trace) * 0.2;
EvtTime_init = find(base_trace(1:end-1)<detection_threshold & base_trace(2:end) >= detection_threshold )+1;
EvtTime_end = find(base_trace(1:end-1)>detection_threshold & base_trace(2:end)<=detection_threshold )+1;

if EvtTime_init(end) > EvtTime_end(end)
    EvtTime_init = EvtTime_init(1:end-1);
end
if EvtTime_end(1) < EvtTime_init(1)
    EvtTime_end = EvtTime_end(2:end);
end    

EvtIntervals = diff(EvtTime_init)/mea_rate;
DiscontinuityIndices = find(EvtIntervals > sessions_time_separation);

StimBegin_Indices = [1, DiscontinuityIndices + 1];
StimEnd_Indices = [DiscontinuityIndices, numel(EvtTime_init)];

events = {};
for i_stim = 1:length(StimBegin_Indices)
    events_begin = EvtTime_init(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    events_end =  EvtTime_end(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    
    if discard_last_event
        events_begin = events_begin(1:end-1);
        events_end = events_end(1:end-1);
    end
        
    events{i_stim}.evtTimes_begin = events_begin;
    events{i_stim}.evtTimes_end =events_end;
    events{i_stim}.evtTimes_hz = round(mea_rate/(median(diff(events{i_stim}.evtTimes_begin))));
    
    % If the last trigger does 
end

fprintf('%i event sessions found:\n', numel(events));
for i_evt = 1:numel(events)
    evt_rate = events{i_evt}.evtTimes_hz;
    evt_intervals = diff(events{i_evt}.evtTimes_begin);
    evt_time_dev = round(max(abs(median(evt_intervals) - evt_intervals)));
    fprintf('\t%i: rate = %i Hz,\t\t n_events = %i,\t\t max_timestep_deviation = %i\n', i_evt, evt_rate, numel(events{i_evt}.evtTimes_begin), evt_time_dev);
end
fprintf('\n\n')
