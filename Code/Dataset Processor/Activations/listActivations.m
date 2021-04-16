function listActivations()
% prints the list of all the activatinos computed in the dataset

load(getDatasetMat(), 'activations')
if ~exist('activations', 'var')
    error_struct.message = strcat("There are no activations yet in this dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
patterns_list = fields(activations);


fprintf('\nList of PSTHs computed in dataset %s:\n', getDatasetId);
for i_pattern = 1:numel(patterns_list)
    pattern = patterns_list{i_pattern};
    fprintf('\t%i: %s\n', i_pattern, pattern);
    
    psths_list = fields(activations.(pattern));
    for i_psth = 1:numel(psths_list)
        psth_label = psths_list{i_psth};
        fprintf('\t\t%i.%i: %s\n', i_pattern, i_psth, psth_label);
        
        act_list = fields(activations.(pattern).(psth_label));
        for i_act = 1:numel(act_list)
            act_label = act_list{i_act};
            fprintf('\t\t\t %s\n', act_label);
        end
    end
    fprintf('\n');
end
fprintf('\n');
