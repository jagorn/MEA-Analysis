function listPSTHs()
% prints the list of all PSTHs saved in the dataset

load(getDatasetMat(), 'psths')
if ~exist('psths', 'var')
    error_struct.message = strcat("There are no psths yet in this dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end  
patterns_list = fields(psths);


fprintf('\nList of PSTHs computed in dataset %s:\n', getDatasetId);
for i_pattern = 1:numel(patterns_list)
    pattern = patterns_list{i_pattern};
    fprintf('\t%i:\t%s\n', i_pattern, pattern);
    
    psths_list = fields(psths(pattern));
    for i_psth = 1:numel(psths_list)
        psth_label = psths_list{i_psth};
        fprintf('\t\t%i:\t%s\n', i_psth, psth_label);
    end
end
fprintf('\n');
