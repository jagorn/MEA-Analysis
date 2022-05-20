function testVisualHoloSynchronization(exp_id, vec_channel)

if ~exist('vec_channel', 'var')
    vec_channel = 4;
end

% load dh and dmd sessions
dh_times = getDHTimes(exp_id);
visual_table = getSectionsTable(exp_id);

for i_dh = 1:numel(dh_times)
    for i_visual = 1:numel(visual_table)
        
        dh_triggers = dh_times{i_dh}.evtTimes_begin;
        dh_durations = dh_times{i_dh}.evtTimes_end - dh_times{i_dh}.evtTimes_begin;
        
        visual_section = visual_table(i_visual);
        
        % check which visual and dh sections overlap
        dh_interval = dh_triggers(1): 1 :  dh_triggers(end);
        visual_interval = visual_section.triggers(1) : 1 : visual_section.triggers(end);
        
        if ~isempty(intersect(dh_interval, visual_interval))
            
            % plot the overlap
            configs = loadConfigs(exp_id, visual_section.id);
           
            if ~isKey(configs, 'version')
                error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'version' is missing");
                error_struct.identifier = strcat('MEA_Analysis:', mfilename);
                error(error_struct);
            end
            version = configs('version');
            
            visual_vec_file = getVecFile(visual_section.stimulus, version);
            visual_vec = importdata(visual_vec_file);
            plotVisualHoloSynchronization(visual_vec, visual_section.triggers, dh_triggers, dh_durations, vec_channel)
            title(strcat(visual_section.id, " overlap with holography"), 'Interpreter', 'None');
        end
        
    end
end

