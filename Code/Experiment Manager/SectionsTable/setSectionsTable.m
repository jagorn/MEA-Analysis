function setSectionsTable(exp_id, sectionsTable)
sections_table_file = fullfile(processedPath(exp_id), 'SectionsTable.mat');
save(sections_table_file, 'sectionsTable');


