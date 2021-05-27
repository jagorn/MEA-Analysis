function stimTable = assignStimTriggers(stimTable, evt_times)
% Assigns to each section of the experiment the corresponding triggers.
% All the triggers are added as a new field 'triggers' to the sections
% struct 'stimTable'.

if numel(stimTable) ~= numel(evt_times)
    fprintf('the number of stimuli listed in the table does not match with the number of trigger sessions found\n')
    
    for i_evt = 1:numel(evt_times)
        triggers = evt_times{i_evt}.evtTimes_begin;
        rate =  evt_times{i_evt}.evtTimes_hz; 
        fprintf('\tsession %i: %i triggers, \t frame rate = %d\n', i_evt, numel(triggers), rate);
    end
    error_struct.message = strcat('the number of visual stimuli does not match with the sessions of triggers found');
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

for i_evt = 1:numel(evt_times)
    triggers = evt_times{i_evt}.evtTimes_begin;
    durations = evt_times{i_evt}.evtTimes_end - evt_times{i_evt}.evtTimes_begin;
    rate = evt_times{i_evt}.evtTimes_hz; 

    stimTable(i_evt).triggers = triggers;
    stimTable(i_evt).durations = durations;
    stimTable(i_evt).rate = rate;
end