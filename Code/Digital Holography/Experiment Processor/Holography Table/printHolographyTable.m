function printHolographyTable(exp_id)
sections = getHolographyTable(exp_id);
try
    table = struct2table(sections);
catch
    table = struct2table(sections, 'AsArray', true);
end
disp(table);