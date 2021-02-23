function H = getHomography(rf1, rf2, exp_id)

% if exp_id is not specified, the homography is supposed to be valid 
% for all the experiments

% load the table
hmat = getHomographiesMat();
if exist(hmat, 'file')
    load(hmat, 'HsTable');
    
    % find out if the homography already exists.
    if exist('exp_id', 'var')
        id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment}));
    else
        id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & cellfun(@isempty, {HsTable.experiment}));
    end
    
    % if it exists more than once, something went wrong.
    if length(id) > 1
        error('Inconsistency in Homographies Table (duplicates).');
        
    elseif length(id) == 1
        H = HsTable(id).H;
        
    else
        error("error: Homography does not exist.")
    end

else    
    error("error: Homography Table does not exist.")
end
