function plotFilteringDHTimes(exp_id, varargin)

% Parameters
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;
raw_filtered_name_def = strcat(exp_id, '_filtered');

dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
frame_duration_def = [];
time_padding_def = 0;
encoding_def = 'uint16';
mea_map_def = double(getMeaPositions());

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Raw_Path', raw_path_def);
addParameter(p, 'Raw_Name', raw_name_def);
addParameter(p, 'Raw_Filtered_Path', raw_path_def);
addParameter(p, 'Raw_Filtered_Name', raw_filtered_name_def);
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'DH_N_Steps', frame_duration_def);
addParameter(p, 'N_Steps_Padding', time_padding_def);
addParameter(p, 'Endcoding', encoding_def);
addParameter(p, 'MEA_Map', mea_map_def);

parse(p, exp_id, varargin{:});

raw_path = p.Results.Raw_Path;
raw_name = p.Results.Raw_Name;
raw_filtered_path = p.Results.Raw_Filtered_Path;
raw_filtered_name = p.Results.Raw_Filtered_Name;
dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
nsteps_dh = p.Results.DH_N_Steps;
nsteps_padding = p.Results.N_Steps_Padding;
encoding = p.Results.Endcoding;
mea_map = p.Results.MEA_Map;

% path
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));
raw_file_filtered = fullfile(raw_filtered_path, strcat(raw_filtered_name, '.raw'));

% get the DH times.
try
    dhTimes = getDHTimes(exp_id);
catch
    error_struct.message = strcat("DH Times not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

n_sessions = numel(dhTimes);
if n_sessions > 1
    n = 0;
    while ~(n > 0 && n <= n_sessions)
        n = input(strcat(num2str(n_sessions), " DH sessions were found: which one do you want to plot? (1 to ", num2str(n_sessions), ")\n"));
    end
else
    n = 1;
end

triggers_begin = dhTimes{n}.evtTimes_begin;
triggers_end = dhTimes{n}.evtTimes_end;
if isempty(nsteps_dh)
    nsteps_dh = min(triggers_end - triggers_begin);
end

whole_nsteps = 2 * nsteps_padding + nsteps_dh;

for time_step = triggers_begin
    plotMEA();
    plotGridMEA();
    plotRawMEA(raw_file, time_step - nsteps_padding, whole_nsteps, mea_map, ...
        'Dead_Electrodes', dead_electrodes, ...
        'Stim_Electrodes', stim_electrodes, ...
        'Encoding', encoding);
    
    plotRawMEA(raw_file_filtered, time_step - nsteps_padding, whole_nsteps, mea_map, ...
        'Dead_Electrodes', dead_electrodes, ...
        'Stim_Electrodes', stim_electrodes, ...
        'Color', [0.5, 0.5, 0.5], ...
        'Encoding', encoding);
    
    title(strcat("Experiment ", exp_id, ", DH Activations (session#", num2str(n), ")"), 'Interpreter', 'None')
    waitforbuttonpress();
    close();
end
