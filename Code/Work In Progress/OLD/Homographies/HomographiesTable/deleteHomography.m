function deleteHomography(rf1, rf2, exp_id)

% if exp_id is not specified, the homography is supposed to be valid 
% for all the experiments
if ~exist('exp_id', 'var')
    exp_id = [];
end

% load the table
hmat = getHomographiesMat();
if exist(hmat, 'file')
    load(hmat, 'HsTable');
    
    % find out if the homography already exists.
    id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment}));
    
    % if it exists more than once, something went wrong.
    if length(id) > 1
        error('Inconsistency in Homographies Table (duplicates).');
        
    elseif length(id) == 1
        HsTable(id) = [];
    else
        fprintf("warning: Homography does not exist.\n")
    end

else    
    fprintf("warning: Homography Table does not exist.\n")
end
save(hmat, 'HsTable');
