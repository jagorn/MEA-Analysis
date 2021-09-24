clear
close all

threshold = 3000;
intra_session_dt = 10;
mea_rate = 20000;
triggers_spacing_repeats = 999;

load('StimChannel_data.mat', 'stimChannel_data');
n_triggers = numel(stimChannel_data);

n_sessions = 1;
repetitions = {};
triggers = {};

triggers{n_sessions} = [];

if stimChannel_data(1) >= threshold
    evt_begins = [evt_begins 1];
end

for t = 2:n_triggers
    if (stimChannel_data(t)  >= threshold) && (stimChannel_data(t-1)  < threshold)
        
        if ~isempty(triggers{n_sessions})
            triggers_session = triggers{n_sessions};
            last_trigger = triggers_session(end);
            dt = t - last_trigger;
            
            if dt > (intra_session_dt * mea_rate)
                repetitions{n_sessions} = triggers(1:triggers_spacing_repeats:end);
                n_sessions = n_sessions + 1;
                triggers{n_sessions} = [];
            end
        end
        
        triggers{n_sessions} = [triggers{n_sessions} t];
    end
end

triggers_session = triggers{n_sessions};
repetitions{n_sessions} = triggers_session(1:triggers_spacing_repeats:end);
save('Euler_Triggers.mat', 'triggers', 'repetitions');



