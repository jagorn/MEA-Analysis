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
addParameter(p, 'Smoothing_Coeff', 0.1);
addParameter(p, 'Time_Spacing', 0);
addParameter(p, 'Label', []);

parse(p, varargin{:});
t_bin = p.Results.Time_Bin;
stimulus = p.Results.Stimulus;
pattern = p.Results.Pattern;
smoothing = p.Results.Smoothing_Coeff;
time_spacing = p.Results.Time_Spacing;
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
        patterns = section.repetitions.names;
        durations = section.repetitions.durations;
        rep_begins = section.repetitions.rep_begins;
    else
        pattern_indices = strcmp(patterns, pattern);
        
        patterns = section.repetitions.names(pattern_indices);
        durations = section.repetitions.durations(pattern_indices);
        rep_begins = section.repetitions.rep_begins(pattern_indices);
    end
    
    
    
    for i_pattern = 1:numel(names)
        if isempty(label)
            pattern_name = names{i_pattern};
        else
            pattern_name = strcat(label, '_', names{i_pattern});
        end
        
        if i_exp == 1 && isfield(psths, pattern_name)
            error_struct.message = strcat("a psth called ", pattern_name, " already exists in this dataset");
            error_struct.identifier = strcat('MEA_Analysis:', mfilename);
            error(error_struct);
        end
        
        psths.(pattern_name).t_bin = t_bin;
        psths.(pattern_name).t_spacing = time_spacing;
        psths.(pattern_name).time_sequences = pattern_psths.time_sequences{i_pattern};
        psths.(pattern_name).psths = pattern_psths.responses{i_pattern};
    end
end
save(getDatasetMat, 'psths', '-append');

fprintf('\nPSTHs succesfully computed.\nThe dataset %s now has the following psths saved:\n', getDatasetId());
psth_fields = fields(psths);
for i_psths = 1:numel(psth_fields)
    fprintf('\t%i: %s\n', i_psths, psth_fields{i_psths});
end
