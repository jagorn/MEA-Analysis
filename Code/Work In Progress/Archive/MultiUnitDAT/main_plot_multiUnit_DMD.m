close all
clear
clc

% INPUT VARIABLES
file_prefix = 'euler_data/euler_sppa0001_';
stim_vec = "euler_stim/EulerStim180530.vec";
stim_nsteps = 999;

% Load Spike Trains
SpikeTimes = extractMultiUnit_dat(file_prefix);

% Compute Trigger Times and Repetitions
cells_idx = 1:256;
dmd_times = SpikeTimes{127};
dmd_rate = median(diff(dmd_times));
[rep_begin, ~, rep_dt] = getConsecutiveStimRepetitions(dmd_times, stim_nsteps);

% Do PSTHs
binSize = .05;
nTBins = round(rep_dt / binSize);
[PSTH, XPSTH, ~] = doPSTH(SpikeTimes, rep_begin, binSize, nTBins, 1, cells_idx);   

% Resample Euler Stim for plots
load(stim_vec)
euler_stim = EulerStim180530(2:end, 2);
euler_rep = euler_stim(1:stim_nsteps);
euler_resampled = interp1(1:stim_nsteps, euler_rep, 1:binSize/dmd_rate:stim_nsteps);
euler_resampled = (euler_resampled - euler_resampled(end));
euler_resampled = euler_resampled / max(euler_resampled) * 10;

% Plot Rasters
l_raster = 16;
for i = 1:l_raster:length(cells_idx)
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1200;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    c_idx = cells_idx(i:(i+l_raster-1));
    doPlotRaster(c_idx, SpikeTimes, rep_begin, rep_begin+rep_dt, 1, 5)
    title_txt = strcat("Electrodes from  #", int2str(c_idx(1)), " to #", int2str(c_idx(end)));
    title(title_txt)
    
    raster_filename = strcat("plots/raster_", int2str(c_idx(1)), "to", int2str(c_idx(end)));
    saveas(gcf, raster_filename, 'jpg');
    close;
end

% Plot PSTHs
for i = 1:length(cells_idx)
    
    figure()
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1200;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    plot(XPSTH, euler_resampled, 'Color', [0.3, 0.3, 0.3], "LineWidth", 1.2)
    hold on
    plot(XPSTH, PSTH(i, :), 'Blue', "LineWidth", 1.8);
    xlabel("Time (s)");
    ylabel("Firing Rate (Hz)");  
    ylim([-20, +125])
    title(strcat("Electrode #", int2str(cells_idx(i))))
    
    psth_filename = strcat("plots/psth_", int2str(cells_idx(i)));
    saveas(gcf, psth_filename, 'jpg');
    close;
end