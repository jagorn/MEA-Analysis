function addHomography(H, rf1, rf2, exp_id)

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
        
    % if it exists, then overwrite it.
    elseif length(id) == 1
        if isempty(exp_id)
            fprintf('info: H from %s to %s already exists. Overwriting..\n', rf1, rf2)
        else
            fprintf('info: H from %s to %s for exp %s already exists. Overwriting..\n', rf1, rf2, exp_id)
        end
        
    % if it does not exist, create a new line.
    else
        id = numel(HsTable) + 1;
        HsTable(id).RF_from = rf1;
        HsTable(id).RF_to = rf2;
        HsTable(id).experiment = exp_id;
    end
    
    % finally add the homography
    HsTable(id).H = H;
    
else    
    % If the table does not exist at all, create a new one from scratch.
    HsTable = struct(   'RF_from', rf1, ...
                        'RF_to', rf2, ...
                        'experiment', exp_id, ...
                        'H', H);
end
save(hmat, 'HsTable');
