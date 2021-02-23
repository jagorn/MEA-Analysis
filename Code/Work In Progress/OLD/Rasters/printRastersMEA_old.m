% Show raster based on threshold detection after artifact removal
close all
clear

% Parameters
expId = '20200131_dh';
dh_session = 'DHMulti';
idx_frame = 1:5:36; % which pattern number do you want to display the responses to? You can try all, the pattern shape will be displayed by the code.
n_reps = 15; % How many trials max do you want to display ?

mea_rate = 20000;
time_before = 0.25 * mea_rate; % How much time before the stim plotted ? In samples (seconds*sampling rate)
time_after = 0.25 * mea_rate; % Muw much time after ? Same unit
duration_stim = 0.5 * mea_rate; % Duration of the stimulus, to modify. Same unit
duration_raster = duration_stim + time_after + time_before;

window_smooth = 500; % Parameter for smoothing - don't worry about it, this is for artifact removal
detect_tresh = 6; % To detect spikes, the threshold is set at mean+ThresFactor*(standard dev). Should be fine for all recordings.

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 1600;
horz = 1600;

dhRepetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions' dh_session '.mat'];
raw_file = [dataPath() '/' expId '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' expId '/PositionsMEA.mat'];

load(dhRepetitionsFile, "test_begin_time");   
load(dhRepetitionsFile, "single_begin_time");   
load(mea_file, 'Positions');


% Multi Spot Rasters
for id_frame = 1:numel(test_begin_time)
    

    rasterFile = [dataPath() '/' expId '/processed/DH/Rasters/Nspot_#', num2str(id_frame)];
    stim_repeats = test_begin_time{id_frame};
    stim_repeats = stim_repeats(1:min(n_reps, length(stim_repeats)));

    % Just display the frames selected
    if all(id_frame ~= idx_frame) && (numel(stim_repeats) >= n_reps)
        continue
    end

    
    % Get the multi unit data
    snippets_mua = extractDataMEA(raw_file, stim_repeats - time_before, duration_raster, 256, 'uint16');
    spike_trains = extractSpikesMEA(snippets_mua, duration_stim, time_before, time_after, detect_tresh, window_smooth);

    % Create the raster
    plotRasterMEA(spike_trains, Positions, duration_raster, time_before, time_after)
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

    saveas(gcf, rasterFile, 'jpg')
    close;
end


% Single Spot Rasters
for id_frame = 1:numel(single_begin_time)
    
    % Just display the frames selected
    if all(id_frame ~= idx_frame)
        continue
    end

    rasterFile = [dataPath() '/' expId '/processed/DH/Plots/Mua_1spot_#', num2str(id_frame)];
    stim_repeats = single_begin_time{id_frame};
    stim_repeats = stim_repeats(1:min(n_reps, length(stim_repeats)));

    % Get the multi unit data
    snippets_mua = extractMultiUnit_raw(raw_file, stim_repeats - time_before, duration_raster);
    spike_trains = getMultiUnitSpikeTimes(snippets_mua, duration_stim, time_before, time_after, detect_tresh, window_smooth);

    % Create the raster
    plotRasterMEA(spike_trains, Positions, duration_raster, time_before, time_after)
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

    saveas(gcf, rasterFile, 'jpg')
    close;
end