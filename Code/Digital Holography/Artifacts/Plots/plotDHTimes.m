function plotDHTimes(exp_id, varargin)

% Parameters
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;

dead_times_path_def = sortedPath(exp_id);
dead_times_name_def = 'dead_times';
show_dead_times_def = true;

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
addParameter(p, 'Show_Dead_Times', show_dead_times_def);
addParameter(p, 'Dead_Times_Path', dead_times_path_def);
addParameter(p, 'Dead_Times_Name', dead_times_name_def);
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'DH_N_Steps', frame_duration_def);
addParameter(p, 'N_Steps_Padding', time_padding_def);
addParameter(p, 'Endcoding', encoding_def);
addParameter(p, 'MEA_Map', mea_map_def);

parse(p, exp_id, varargin{:});

raw_path = p.Results.Raw_Path;
raw_name = p.Results.Raw_Name;
show_dead_times = p.Results.Show_Dead_Times;
dead_times_path = p.Results.Dead_Times_Path;
dead_times_name = p.Results.Dead_Times_Name;
dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
nsteps_dh = p.Results.DH_N_Steps;
nsteps_padding = p.Results.N_Steps_Padding;
encoding = p.Results.Endcoding;
mea_map = p.Results.MEA_Map;

% path
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));
dead_times_file =  fullfile(dead_times_path, strcat(dead_times_name, '.txt'));

% get the DH times.
try
    dhTimes = getDHTimes(exp_id);
catch
    error_struct.message = strcat("DH Times not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% get dead times
if show_dead_times
    if isfile(dead_times_file)
        dead_times = importdata(dead_times_file);
    else
        warning(strcat("dead times file ", dead_times_file, " not found"))
        dead_times = [];
    end
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
    nsteps_dh = median(triggers_end - triggers_begin);
end


figure()
whole_nsteps = 2 * nsteps_padding + nsteps_dh;
for time_step = triggers_begin
    plotMEA();
    plotGridMEA();
    
    first_step = time_step - nsteps_padding;
    last_step = first_step + whole_nsteps;
    
    plotRawMEA(raw_file, first_step, whole_nsteps, mea_map, ...
        'Dead_Electrodes', dead_electrodes, ...
        'Stim_Electrodes', stim_electrodes, ...
        'Encoding', encoding);
    
    if show_dead_times && ~isempty(dead_times)
        dt_idx1 = dead_times(:, 1) <= first_step & dead_times(:, 2) > first_step;
        dt_idx2 = dead_times(:, 1) > first_step & dead_times(:, 1) < last_step;
        dt_idx = dt_idx1 | dt_idx2;
        
        dead_times_windows = dead_times(dt_idx, :) - first_step;
        dead_times_windows(dead_times_windows(:, 1) < 0, 1) = 0;
        dead_times_windows(dead_times_windows(:, 2) > whole_nsteps, 2) = whole_nsteps;

        plotTimeWindowsMEA(dead_times_windows, whole_nsteps, mea_map)
    end
    
    title(strcat("Experiment ", exp_id, ", DH Activations (session#", num2str(n), ")"), 'Interpreter', 'None')
    waitforbuttonpress();
    hold off;
end
