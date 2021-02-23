clear

expId =  '20200109_a2';
mea_rate = 20000;
dh_spacing = 0.25; % s
dh_duration = 0.50;

dh_triggers_file = strcat(dataPath, "/", expId, "/processed/DH/DHTimes.mat");
dead_times_file = strcat(dataPath, "/", expId, "/sorted/dead_times_patterns.txt");

load(dh_triggers_file, 'dhTimes')
load(dead_times_file)

dead_inits = dead_times_patterns(:, 1);
dead_ends = dead_times_patterns(:, 2);

% Get all Stim Repetitions
triggers = [];
for i_dh = 1:numel(dhTimes)
    triggers = [triggers dhTimes{i_dh}.evtTimes_begin(:)'];
end

% build figure with background rectangle representing holo stimulation
figure()
xlim([-dh_spacing, dh_duration + dh_spacing])
ylim([0, length(triggers)])

xlabel("Time (s)")
ylabel("Triggers")

rect_color = [.6 .9 .9];
rect_edges = [0, 0, dh_duration, length(triggers)];
dh_plot = rectangle('Position', rect_edges,'FaceColor', rect_color, 'LineStyle', 'none');
hold on

% add a stripe o spike trains for each pattern
for i_t = 1:length(triggers)
    t_init = triggers(i_t);
    t_end = t_init + dh_duration*mea_rate;

    dead_init_segment = and(dead_inits > t_init - dh_spacing*mea_rate, dead_inits < t_end + dh_spacing*mea_rate);
    dead_end_segment = and(dead_ends > t_init - dh_spacing*mea_rate, dead_ends < t_end + dh_spacing*mea_rate);
    
    dead_segment = or(dead_init_segment, dead_end_segment);
    
    for dead_i = find(dead_segment)'
        dt_init = (dead_inits(dead_i) - t_init)/mea_rate;
        dt_end = (dead_ends(dead_i) - t_init)/mea_rate;
        
        rect_edges = [dt_init, i_t-1, dt_end - dt_init, 1];
        dt_plot = rectangle('Position', rect_edges,'FaceColor', [1, 0, 0, 0.3], 'LineStyle', 'none');
    end
end