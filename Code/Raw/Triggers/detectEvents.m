function events = detectEvents(raw_trace, sessions_time_separation, mea_rate)
% Detects events trepassing a threshold in a given  raw trace
% Contiguous events are grouped together in sessions 
% INPUTS:
% raw_trace: the raw trace
% detection_threshold: the threshold used to detect an event.
% sessions_time_separation: the max time interval between two events
%                           belonging to the same session (seconds)
% mea_rate: the trace rate (Hz)
% OUTPUT:
% events: a cell array (one per events session) specifying 
%         start and end of each event


raw_trace = abs(raw_trace(:)' - median(raw_trace));
detection_threshold = max(raw_trace) * 0.2;

EvtTime_init = find(raw_trace(1:end-1)<detection_threshold & raw_trace(2:end) >= detection_threshold )+1;
EvtTime_end = find(raw_trace(1:end-1)>detection_threshold & raw_trace(2:end)<=detection_threshold )+1;

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
    events{i_stim}.evtTimes_begin = EvtTime_init(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    events{i_stim}.evtTimes_end = EvtTime_end(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    events{i_stim}.evtTimes_hz = round(mea_rate/(median(diff(events{i_stim}.evtTimes_begin))));
end

fprintf('%i event sessions found:\n', numel(events));
for i_evt = 1:numel(events)
    evt_rate = events{i_evt}.evtTimes_hz;
    evt_time_dev = round(max(abs(median(diff(events{i_evt}.evtTimes_begin)) - diff(events{i_evt}.evtTimes_begin))));
    fprintf('\t%i: rate = %i Hz,\t\t n_events = %i,\t\t max_timestep_deviation = %i\n', i_evt, evt_rate, numel(events{i_evt}.evtTimes_begin), evt_time_dev);
end
fprintf('\n\n')
