function listPSTHs()
% lists all the PSTHs saved in the dataset

load(getDatasetMat, 'psths');
if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fprintf('\nThe dataset %s has the following psths saved:\n', getDatasetId());
psth_fields = fields(psths);
for i_psths = 1:numel(psth_fields)
    fprintf('\t%i: %s\n', i_psths, psth_fields{i_psths});
end
fprintf('\n');
