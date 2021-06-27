function testVisualHoloSynchronization(exp_id, vec_channel)

% load dh and dmd sessions
dh_table = getHolographyTable(exp_id);
visual_table = getSectionsTable(exp_id);

for i_dh = 1:numel(dh_table)
    for i_visual = 1:numel(visual_table)
        
        dh_section = dh_table(i_dh);
        visual_section = visual_table(i_visual);
        
        % check which visual and dh sections overlap
        dh_interval = fixed.Interval(dh_section.triggers(1), dh_section.triggers(end));
        visual_interval = fixed.Interval(visual_section.triggers(1), visual_section.triggers(end));
        
        if overlaps(dh_interval, visual_interval)
            
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
            plotVisualHoloSynchronization(visual_vec, visual_section.triggers, dh_section.triggers, dh_section.durations, vec_channel)
            title(strcat(visual_section.id, " overlap with ", dh_section.id), 'Interpreter', 'None');
        end
        
    end
end

