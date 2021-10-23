function H = getHomography(rf1, rf2, exp_id)

% load the table
HsTable = getHomographiesTable();

% find out if the homography already exists.
if exist('exp_id', 'var')
    % if exp_id is not specified, the homography is valid for all the experiments
    idx_exp = strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment});
    idx_generic = strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & cellfun(@isempty, {HsTable.experiment});
    id = find(idx_exp | idx_generic);
else
    id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & cellfun(@isempty, {HsTable.experiment}));
end

if length(id) == 1
    H = HsTable(id).H;    
    
elseif length(id) > 1
    % if it exists more than once, something went wrong.
    error_struct.message = 'Inconsistency in Homographies Table (duplicates).';
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
    
else
    if ~exist('exp_id', 'var')
        error_struct.message = strcat("error: Homography ", rf1,  " ==> ", rf2, " does not exist.");
    else
        error_struct.message = strcat("error: Homography ", rf1,  " ==> ", rf2, " (", exp_id, ") does not exist.");
    end
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

