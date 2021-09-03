clear
close all

intra_session_dt = 10;
mea_rate = 20000;

load('triggers_channel.mat');
n_triggers = numel(triggers_channel);
n_sessions = 1;

evtTimes = {};


evtTimes{n_sessions}.evtTimes_begins = [];
evtTimes{n_sessions}.evtTimes_ends = [];

if triggers_channel(1) == 256
    evt_begins = [evt_begins 1];
end

for t = 2:n_triggers
    if (triggers_channel(t) == 256) && (triggers_channel(t-1) == 0)
        
        if ~isempty(evtTimes{n_sessions}.evtTimes_begins)
            last_trigger = evtTimes{n_sessions}.evtTimes_begins(end);
            dt = t - last_trigger;
            
            if dt > (intra_session_dt * mea_rate)
                n_sessions = n_sessions + 1;
                evtTimes{n_sessions}.evtTimes_begins = [];
                evtTimes{n_sessions}.evtTimes_ends = [];
            end
        end
        
        evtTimes{n_sessions}.evtTimes_begins = [evtTimes{n_sessions}.evtTimes_begins t];
    end
    
    if (triggers_channel(t) == 0) && (triggers_channel(t-1) == 256)
        evtTimes{n_sessions}.evtTimes_ends = [evtTimes{n_sessions}.evtTimes_ends t];
    end
end

if triggers_channel(n_triggers) == 256
    evtTimes{n_sessions}.evtTimes_ends = [evtTimes{n_sessions}.evtTimes_ends n_triggers];
end

save('EvtTimes.mat', 'evtTimes');



