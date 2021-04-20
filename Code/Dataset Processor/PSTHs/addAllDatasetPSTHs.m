function addAllDatasetPSTHs(varargin)
% Computes and adds all the PSTHs available to the dataset.
% This function can only be used on datasets composed by one only experiment.

% INPUTS:
% time_bin (optional):                  the time bin of the psth.
% smoothing_coefficient (optional):     smoothing coefficient of the psth
% time_spacing (optional):              time interval (in seconds) before/after the stimulus onset/offset
% label (optional):                     label added to the psths saved in the dataset

% Parse Input
p = inputParser;
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Stimulus', []);
addParameter(p, 'Pattern', []);
addParameter(p, 'Smoothing_Coeff', 0);
addParameter(p, 'Time_Spacing', 0);
addParameter(p, 'Add_Duplicates', false);
addParameter(p, 'Label', []);

parse(p, varargin{:});
t_bin = p.Results.Time_Bin;
stimulus = p.Results.Stimulus;
pattern = p.Results.Pattern;
smoothing = p.Results.Smoothing_Coeff;
time_spacing = p.Results.Time_Spacing;
add_duplicates = p.Results.Add_Duplicates;
label = p.Results.Label;

load(getDatasetMat, 'experiments', 'spikes', 'psths');
n_exp = numel(experiments);

% This function can only be used on datasets composed by one only experiment.
if n_exp ~= 1
    error_struct.message = "This function can only be used on datasets composed by one only experiment.";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% load variables
if ~exist('psths', 'var')
    psths = [];
end

% get the sections table
exp_id = getExpId();
mea_rate = getDatasetMeaRate();
sections_table = getSectionsTable(exp_id);

% if a stimulus was chosen, esclude from the table all other stimuli
if ~isempty(stimulus)
    stim_indices = strcmp([sections_table.stimulus], stimulus);
    if ~any(stim_indices)
        error_struct.message = strcat("Stimulus ", stimulus, " not found in experiment ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    sections_table = sections_table(stim_indices);
end

% Compute PSTHs
for i_section = 1:numel(sections_table)
    
    section = sections_table(i_section);
    pattern_psths = sectionPSTHs(spikes, section.repetitions, mea_rate, ...
        'Time_Bin', t_bin, ...
        'Time_Spacing', time_spacing, ...
        'Smoothing', smoothing);
    
    % if a patterns was chosen, esclude from the table all other patterns
    if isempty(pattern)
        pattern_indices = 1:numel(pattern_psths.patterns);
    else
        pattern_indices = find(strcmp(pattern_psths.patterns, pattern));
    end
    
    % for each pattern, save the psth.
    for i_pattern = pattern_indices
        pattern_type = pattern_psths.patterns{i_pattern};
        psth_label = createPSTHLabel(label, section.conditions);
        
        % if the psth label exists already, add a duplicate suffix
        if isfield(psths, pattern_type) && isfield(psths.(pattern_type), psth_label)
            fprintf("A psth called %s for pattern %s already exists in this dataset.\n", psth_label, pattern_type);
            if add_duplicates
                duplicate_suffix = 2;
                while isfield(psths, strcat(psth_label, '_', num2str(duplicate_suffix)))
                    duplicate_suffix = duplicate_suffix+1;
                end
                psth_label = strcat(psth_label, '_', num2str(duplicate_suffix));
                fprintf("The new psth will be saved with name %s instead.\n", psth_label);
            end
        end
        
        % save everything
        psths.(pattern_type).(psth_label).t_bin = t_bin;
        psths.(pattern_type).(psth_label).t_spacing = time_spacing;
        psths.(pattern_type).(psth_label).time_sequences = pattern_psths.time_sequences{i_pattern};
        psths.(pattern_type).(psth_label).psths = pattern_psths.responses{i_pattern};
        psths.(pattern_type).(psth_label).firing_rates = pattern_psths.firing_rates{i_pattern};
        psths.(pattern_type).(psth_label).stim_rate = section.rate;
    end
end
save(getDatasetMat, 'psths', '-append');

fprintf('\nPSTHs succesfully computed.\nThe dataset %s now has the following psths saved:\n', getDatasetId());
listPSTHs();
