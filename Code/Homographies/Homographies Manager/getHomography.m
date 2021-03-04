function H = getHomography(rf1, rf2, exp_id)

% load the table
HsTable = getHomographiesTable();

% find out if the homography already exists.
if exist('exp_id', 'var')
    % if exp_id is not specified, the homography is valid for all the experiments
    id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment}));
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
    error_struct.message = "error: Homography does not exist.";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
