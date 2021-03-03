function initializeHomographiesMat()

hmat_file = fullfile(homographiesPath(), 'Homographies.mat');
if isfile(hmat_file)
    warning("the homographies .mat is already initialized");
else
    HsTable = struct('RF_from', [], ...
        'RF_to', [], ...
        'experiment', [], ...
        'H', []);
    save(hmat_file,  'HsTable');
end

