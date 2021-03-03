function deleteHomography(rf1, rf2, exp_id)

% if exp_id is not specified, the homography is supposed to be valid 
% for all the experiments
if ~exist('exp_id', 'var')
    exp_id = [];
end

% load the table
HsTable = getHomographiesTable();

    
% find out if the homography already exists.
id = find(strcmp(rf1, {HsTable.RF_from}) & strcmp(rf2, {HsTable.RF_to}) & strcmp(exp_id, {HsTable.experiment}));

if length(id) == 1
    HsTable(id) = [];
    
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

setHomographiesTable(HsTable);