function stas_file = getSTAsFile(exp_id, label)

if ~exist('label', 'var') || isempty(label) || (label == "")
    file_name = 'Sta.mat';
else
    file_name = strcat('Sta_', label, '.mat');
end

stas_file = fullfile(processedPath(exp_id), file_name);

