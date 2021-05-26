function setHolographyTable(exp_id, holographyTable)
sections_table_file = fullfile(holoPath(exp_id), 'HolographyTable.mat');
save(sections_table_file, 'holographyTable');


