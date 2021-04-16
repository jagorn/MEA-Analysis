function [psth_pattern, psth_label] = getDefaultPSTH()
% return the label of the default PSTH.
% the default PSTH is the PSTH that is shown in all the plots and cards.
% it can be changed using the method "changeDefaultPattern

global default_psth

if isempty(default_psth)
    
    load(getDatasetMat, 'psths');
    if ~exist('psths', 'var')
        error_struct.message = strcat(getDatasetId(), " has no psths yet");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    patterns = fields(psths);  
    first_pattern = patterns{1};
    
    labels = fields(psths.(first_pattern));
    first_label = labels{1};
    default_psth = {first_pattern, first_label};
    
end

psth_pattern = default_psth{1};
psth_label = default_psth{2};


