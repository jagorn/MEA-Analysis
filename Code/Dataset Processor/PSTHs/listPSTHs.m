function listPSTHs()
% prints the list of all PSTHs saved in the dataset
psths_list = getPsthsList();

fprintf('\nList of PSTHs computed in dataset %s:\n', getDatasetId);
for i_psth = 1:numel(psths_list)
    fprintf('\t%i:\t%s\n', i_psth, psths_list{i_psth});
end
fprintf('\n');
