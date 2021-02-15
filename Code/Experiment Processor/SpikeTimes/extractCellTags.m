function Tags = extractCellTags(exp_id, templates_file)
% Extracts the cell tags of a given experiment from the spike-sorting
% results.

try
    Tags = getTags(exp_id);
    disp("Cell tags were already extracted. They will be loaded instead.")
catch
    Tags = readTags(templates_file);
    setTags(exp_id, Tags)
    disp("Cell tags extracted")
end
