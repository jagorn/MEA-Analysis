function saveRepetitions(exp_id)
sections_table = getSectionsTable(exp_id);

for i_section = 1:numel(sections_table)
    section_table = sections_table(i_section);
    reps_file = fullfile(sectionPath(exp_id, section_table.id), 'repetitions.mat');
    
    try
        triggers = section_table.triggers;
        if ~isempty(triggers)
            save(reps_file, 'triggers')
        end
        
        repetitions = section_table.repetitions;
        if ~isempty(repetitions)
            save(reps_file, 'repetitions', '-append')
            fprintf('repetitions saved for section %s\n', section_table.id);
        end
    catch
    end
    
end


