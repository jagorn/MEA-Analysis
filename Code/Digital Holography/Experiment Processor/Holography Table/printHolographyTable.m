function printHolographyTable(exp_id)
sections = getHolographyTable(exp_id);
table = struct2table(sections);
disp(table);