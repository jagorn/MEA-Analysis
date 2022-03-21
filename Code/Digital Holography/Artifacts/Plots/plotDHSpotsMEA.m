function plotDHSpotsMEA(exp_id, dh_id, varargin)

% Parameters
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;

dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];

n_steps_padding_def = 100;
encoding_def = 'uint16';
mea_map_def = double(getMeaPositions());
mea_spacing_def = 30;

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'dh_id');
addParameter(p, 'Raw_Path', raw_path_def);
addParameter(p, 'Raw_Name', raw_name_def);
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'N_Steps_Padding', n_steps_padding_def);
addParameter(p, 'Endcoding', encoding_def);
addParameter(p, 'MEA_Spacing', mea_spacing_def);
addParameter(p, 'MEA_Map', mea_map_def);

parse(p, exp_id, dh_id, varargin{:});

raw_path = p.Results.Raw_Path;
raw_name = p.Results.Raw_Name;

dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;

nsteps_padding = p.Results.N_Steps_Padding;
encoding = p.Results.Endcoding;

mea_spacing = p.Results.MEA_Spacing;
mea_map = p.Results.MEA_Map;

% path
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));

% get the DH Session.
try
    h_table = getHolographyTable(exp_id);
    stimulus = h_table(dh_id).stimulus;
    dh_patterns = h_table(dh_id).repetitions;
    positions = h_table(dh_id).positions.mea;
catch
    error_struct.message = strcat("Holography Table not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if isempty(dh_patterns) || isempty(positions)
    error_struct.message = strcat("Holography Repetitions (or spot positions) not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


figure()
for i_pattern = 1:numel(dh_patterns.rep_begins)
    
    
    repetitions = dh_patterns.rep_begins{i_pattern};
    duration = dh_patterns.durations(i_pattern);
    pattern = logical(dh_patterns.patterns(i_pattern, :));
    spots = positions(pattern, :) / mea_spacing
    
    if sum(pattern) > 1
        continue;
    end
    
    for i_rep = 1:min(3, numel(repetitions))
        repetition = repetitions(i_rep);
        
        whole_nsteps = round(2 * nsteps_padding + duration);
        first_step = repetition - nsteps_padding;
        
        plotMEA();
        plotGridMEA();
        plotRawMEA(raw_file, first_step, whole_nsteps, mea_map, ...
            'Dead_Electrodes', dead_electrodes, ...
            'Stim_Electrodes', stim_electrodes, ...
            'Encoding', encoding);
        
        dh_plot = scatter(spots(:, 1), spots(:, 2), 50, 'r', 'Filled');
        
        title(strcat("Experiment ", exp_id, ", ", stimulus, " (Pattern #", num2str(i_pattern), ", Repetition ", num2str(i_rep), ")"), 'Interpreter', 'None')
        waitforbuttonpress();
        hold off;
    end
end
