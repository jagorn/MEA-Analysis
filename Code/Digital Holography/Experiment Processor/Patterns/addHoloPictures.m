function addHoloPictures(exp_id)

holo_table = getHolographyTable(exp_id);

for i_section = 1:numel(holo_table)
    holo_section = holo_table(i_section);
    dh_section = holo_section.stimulus;
    
    yes_or_no = input(strcat("would you like to add a picture for the holography section ", dh_section, "? (Y/n)"), 's');
    if strcmp(yes_or_no, 'y') || strcmp(yes_or_no, 'Y')
        
        [file, path] = uigetfile(strcat(holoPath(exp_id), '.jpg'));
        if isequal(file,0)
            continue;
        else
            holo_table(i_section).image = fullfile(path, file);
            disp(strcat("image ", file, " saved in section ", dh_section));
        end
    end
end
setHolographyTable(exp_id, holo_table);