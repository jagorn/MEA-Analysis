function addDatasetPSTH(stim_id, varargin)
% Computes and adds a new PSTH to the dataset.

% INPUTS:
% stim_id:                              the id of the stimulus on which to compute the psth (examples: flicker, euler).
% time_bin (optional):                  the time bin of the psth.
% smoothing_coefficient (optional):     smoothing coefficient of the psth
% time_spacing (optional):              time interval (in seconds) before/after the stimulus onset/offset
% patterns (optional):                  the repeated patterns of the stimulus on which to compute the PSTH
% label (optional):                     label added to the psths saved in the dataset

% Parse Input
p = inputParser;
addRequired(p, 'stim_id');
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Smoothing_Coeff', 0.1);
addParameter(p, 'Time_Spacing', 0);
addParameter(p, 'Patterns', []);
addParameter(p, 'Label', []);

parse(p, stim_id, varargin{:});
t_bin = p.Results.Time_Bin;
smoothing = p.Results.Smoothing_Coeff;
time_spacing = p.Results.Time_Spacing;
patterns = p.Results.Patterns;
label = p.Results.Label;

% load variables
load(getDatasetMat, 'cellsTable', 'experiments', 'psths');
if ~exist('psths', 'var')
    psths = [];
end
n_exp = numel(experiments);

% Find sections with stim_id in each experiment
exp_tables = cell(1, n_exp);
for i_exp = 1:n_exp
    exp_id = experiments{i_exp};
    table = findSections(exp_id, stim_id);
    
    if isempty(table)
        error_struct.message = strcat(stim_id, " does not exist in ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    exp_tables{i_exp} = table;
end

% For each experiment, if there are multiple sections with stim_id, choose one
for i_exp = 1:n_exp
    table = exp_tables{i_exp};
    exp_id = experiments{i_exp};
    
    if numel(table) > 1
        fprintf('\nExperiment %s has several sections with stimulus %s.\n', exp_id, stim_id)
        fprintf('Which ones do you want to use?\n')
        for i_entry = 1:numel(table)
            fprintf('\t%i)\t%s\n', i_entry, table(i_entry).id);
        end
        i_section = input(strcat("Type the number of the section (1 to ", num2str(numel(table)), ") to use.\n"));
        if i_section < 1 || i_section > numel(table)
            error_struct.message = "selection invalid";
            error_struct.identifier = strcat('MEA_Analysis:', mfilename);
            error(error_struct);
        end
        exp_tables{i_exp} = table(i_section);
    end
end

% if the user specified the patterns, remove all the unwanted patterns
if ~isempty(patterns)
    for i_exp = 1:n_exp
        exp_id = experiments{i_exp};
        table = exp_tables{i_exp};
        
        pattern_indices = [];
        for pattern = patterns
            if ~contains(pattern, table.repetitions.names)
                error_struct.message = strcat(exp_id, " does not contain a pattern called ", pattern);
                error_struct.identifier = strcat('MEA_Analysis:', mfilename);
                error(error_struct);
            end
            pattern_indices = [pattern_indices, find(table.repetitions.names == pattern)];
        end
        
        exp_tables{i_exp}.repetitions.names = exp_tables{i_exp}.repetitions.names(pattern_indices);
        exp_tables{i_exp}.repetitions.durations = exp_tables{i_exp}.repetitions.durations(pattern_indices);
        exp_tables{i_exp}.repetitions.rep_begins = exp_tables{i_exp}.repetitions.rep_begins(pattern_indices);
    end
end

% Make sure all sections have same parameters:

% repetition parameters
n_steps = exp_tables{1}.repetitions.durations;
names = exp_tables{1}.repetitions.names;
frame_rate = exp_tables{1}.rate;

% configuration parameters
exp_id = experiments{1};
section_id = exp_tables{1}.id;
config_file = configFile(exp_id, section_id);
config_map = parseConfigurationFile(config_file);
configs_are_the_same = true;

for i_exp = 2:n_exp
    exp_id = experiments{i_exp};
    repetitions = exp_tables{i_exp}.repetitions;
    
    if  ~isequal(n_steps, repetitions.durations) || ...
            ~isequal(names, repetitions.names) || ...
            ~isequal(frame_rate, exp_tables{i_exp}.rate)
        
        error_struct.message = strcat("repeated patterns are different: you cannot pool these sections");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    
    % configuration parameters
    config_file = configFile(exp_id, section_id);
    configs_are_the_same = configs_are_the_same && isequal(config_map, parseConfigurationFile(config_file));
end
if ~configs_are_the_same
    warning('Attention: you are pooling sections with different configurations.');
end

% Finally, we compute PSTHs
mea_rate = getDatasetMeaRate();

for i_exp = 1:n_exp
    exp_id = experiments{i_exp};
    exp_cells = [cellsTable.experiment] == exp_id;
    exp_indices = [cellsTable(exp_cells).N];
    
    repetitions = exp_tables{i_exp}.repetitions;
    spike_times = getSpikeTimes(exp_id);

    exp_psths = sectionPSTHs(spike_times, repetitions, mea_rate, 'Time_Bin', t_bin, 'Time_Spacing', time_spacing, 'Smoothing', smoothing, 'Cell_Indices', exp_indices);
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
        psths.(pattern_name).time_sequences = exp_psths.time_sequences{i_pattern};
        psths.(pattern_name).psths(exp_cells, :) = exp_psths.responses{i_pattern};
    end
end
save(getDatasetMat, 'psths', '-append');

fprintf('\nPSTHs succesfully computed.\nThe dataset %s now has the following psths saved:\n', getDatasetId());
psth_fields = fields(psths);
for i_psths = 1:numel(psth_fields)
    fprintf('\t%i: %s\n', i_psths, psth_fields{i_psths});
end
