function addHomography(H, rf1, rf2, exp_id)

% load the table
HsTable = getHomographiesTable();

% find out if the homography already exists.
if exist('exp_id', 'var')
    % if exp_id is not specified, the homography is valid for all the experiments
    id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment}));
else
    id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & cellfun(@isempty, {HsTable.experiment}));
end

if length(id) < 1
    % if it does not exist, create a new line.
    id = numel(HsTable) + 1;
    HsTable(id).RF_from = rf1;
    HsTable(id).RF_to = rf2;
    HsTable(id).experiment = [];
    HsTable(id).H = H;
    
    if exist('exp_id', 'var')
        HsTable(id).experiment = exp_id;
    end
    
elseif length(id) == 1
    % if it exists, then overwrite it.
    if exist('exp_id', 'var')
        fprintf('info: H from %s to %s for exp %s already exists. Overwriting..\n', rf1, rf2, exp_id)
    else
        fprintf('info: H from %s to %s already exists. Overwriting..\n', rf1, rf2)
    end
    HsTable(id).H = H;
    
else
    % if it exists more than once, something went wrong.
    error_struct.message = 'Inconsistency in Homographies Table (duplicates).';
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

setHomographiesTable(HsTable);

