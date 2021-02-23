function listHomographies()

% load the table
hmat = getHomographiesMat();
if exist(hmat, 'file')
    load(hmat, 'HsTable');
    
    for i = 1:numel(HsTable)
        if isempty(HsTable(i).experiment)
            fprintf('\t%i. %s => %s\n', i, HsTable(i).RF_from, HsTable(i).RF_to)
        else
            fprintf('\t%i. %s => %s (experiment %s)\n', i, HsTable(i).RF_from, HsTable(i).RF_to, HsTable(i).experiment)
        end
    end
    fprintf('\n');
        
else    
    fprintf("warning: Homography Table does not exist.\n")
end
