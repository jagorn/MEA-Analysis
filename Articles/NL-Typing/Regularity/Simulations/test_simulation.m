clear
close all
clc

% Simulation Parameters
do_plot = false;
s_roi = 500;
s_n_cells = 9;
s_radii =  65;
s_noises = 10;
s_iterations = 1:100;

% load
mat_suffix = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/regularity_test/regularity_test";
ri_mat_file = '/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/regularity_test/regularity_test.mat';
load(ri_mat_file, 'good_ers', 'good_nnris', 'rnd_ers', 'rnd_nnris');

% plot params
screen_size = get(0,'screensize');
screen_width = screen_size(3);
screen_height = screen_size(4);
    
while true
    
    % simulation to test
    i_n_cells = randi(numel(s_n_cells));
    i_radius = randi(numel(s_radii));
    i_noise = randi(numel(s_noises));
    i_iteration = randi(numel(s_iterations));
    
    n_cells = s_n_cells(i_n_cells);
    radius = s_radii(i_radius);
    noise = s_noises(i_noise);
    iteration = s_iterations(i_iteration);
    
    % Load
    good_points_mat_file = strcat(mat_suffix, "_good_n", num2str(n_cells), ".mat");
    rnd_points_mat_file = strcat(mat_suffix, "_rnd_n", num2str(n_cells), ".mat");
    load(good_points_mat_file, "good_points");
    load(rnd_points_mat_file, "rnd_points");
    
    good_points_simulation = good_points(:, :, i_radius, i_noise, i_iteration);
    rnd_points_simulation = rnd_points(:, :, i_iteration);
    
    good_nnri = good_nnris(i_n_cells, i_radius, i_noise, i_iteration);
    good_er = good_ers(i_n_cells, i_radius, i_noise, i_iteration);
    rnd_nnri = rnd_nnris(i_n_cells, i_iteration);
    rnd_er = rnd_ers(i_n_cells, i_iteration);
    
    if any(isnan(good_points_simulation(:)))
        warning("points were null for this simulation");
    else
        [good_nnri_recomp, ~, good_er_recomp] = computeRegularityIndices(good_points_simulation, [], [s_roi s_roi], [], 'ER_Max', s_roi, 'NN_Max', s_roi);
        showMosaicRegularity(good_points_simulation, [s_roi s_roi], 'NNRI', good_nnri_recomp, 'ER', good_er_recomp, 'RFs', createRFs(good_points_simulation, radius));
        suptitle(strcat("GOOD MOSAIC - N=", num2str(n_cells), ", R=", num2str(radius), ", noise=", num2str(noise), ", NNRI=", num2str(good_nnri), ", ER=", num2str(good_er)));
        set(gcf,'Position',[0, 0, screen_width*3/2, screen_height/3]);
    end
    
    [rnd_nnri_recomp, ~, rnd_er_recomp] = computeRegularityIndices(rnd_points_simulation, [], [s_roi s_roi], [], 'ER_Max', s_roi, 'NN_Max', s_roi);
    showMosaicRegularity(rnd_points_simulation, [s_roi s_roi], 'NNRI', rnd_nnri_recomp, 'ER', rnd_er_recomp, 'RFs', createRFs(rnd_points_simulation, 50));
    suptitle(strcat("RANDOM MOSAIC - N=", num2str(n_cells), ", NNRI=", num2str(rnd_nnri), ", ER=", num2str(rnd_er)));
    set(gcf,'Position',[0, screen_height/2, screen_width*3/2, screen_height/3]);

    pause();
    close("all");
    
end




