clear
close all
clc

% Simulation Parameters
do_plot = false;
s_roi = 500;
s_n_cells = 5:2:9;
s_radii = [50 65 80];
s_noises = [5 10 15];
s_iterations = 1:100;


% load
mat_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/regularity_test/regularity_test.mat";
mat_suffix = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/regularity_test/regularity_test";
load(mat_file, "mosaic_nnds", "mosaic_sizes");

% check data statistics
mosaic_radius_median = zeros(numel(mosaic_nnds), 1);
mosaic_radius_std = zeros(numel(mosaic_nnds), 1);
for i_nnd = 1:numel(mosaic_nnds)
    mosaic_radius_median(i_nnd) = median(mosaic_nnds{i_nnd}/2);
    mosaic_radius_std(i_nnd) = std(mosaic_nnds{i_nnd}/2);
end

% simulate good mosaics
good_nnris = zeros(numel(s_n_cells), numel(s_radii), numel(s_noises), numel(s_iterations));
good_ers = zeros(numel(s_n_cells), numel(s_radii), numel(s_noises), numel(s_iterations));

fprintf("Processing Simulations Good Mosaics\n...");
for i_cells = 1:numel(s_n_cells)
    n_cells = s_n_cells(i_cells);
    good_points = zeros(n_cells, 2, numel(s_radii), numel(s_noises), numel(s_iterations));
    mat_file_good_points = strcat(mat_suffix, "_good_n", num2str(n_cells), ".mat");
    fprintf("\tsimulating for %i cells (%i/%i)...\n...", n_cells, i_cells, numel(s_n_cells));
    
    for i_radius = 1:numel(s_radii)
        radius = s_radii(i_radius);
        fprintf("\t\tsimulating for radius = %i (%i/%i)...\n...", radius, i_radius, numel(s_radii));
        
        for i_noise = 1:numel(s_noises)
            noise = s_noises(i_noise);
            fprintf("\t\t\tsimulating for noise = %i (%i/%i)...\n...", noise, i_noise, numel(s_noises));
            
            for i_iteration = 1:numel(s_iterations)
                iteration = s_iterations(i_iteration);
                
                points = simulateValidMosaic(s_roi, radius, n_cells, noise, do_plot);
                [nnri, ~, er] = computeRegularityIndices(points, [], [s_roi s_roi], [], 'ER_Max', s_roi, 'NN_Max', s_roi);
                
                good_points(:, :, i_radius, i_noise, i_iteration) = points;
                good_nnris(i_cells, i_radius, i_noise, i_iteration) = nnri.ri;
                good_ers(i_cells, i_radius, i_noise, i_iteration) = er.effective_radius;
                
                
                if do_plot
                    showMosaicRegularity(points, [s_roi s_roi], 'NNRI', nnri, 'ER', er, 'RFs', createRFs(points, radius));
                    fullScreen(); pause(); close("all");
                end
            end
            save(mat_file_good_points, "good_points");
            fprintf("\t\t\t..partial saving done\n...");
        end
    end
    save(mat_file_good_points, "good_points");
    fprintf("\t..final saving done\n...");
end
save(mat_file, "good_nnris", "good_ers", "-append");
fprintf("...done\n\n");

% % simulate random mosaics
% rnd_nnris = zeros(numel(s_n_cells), numel(s_iterations));
% rnd_ers = zeros(numel(s_n_cells), numel(s_iterations));
% 
% fprintf("Processing Simulations Random Mosaics\n...");
% for i_cells = 1:numel(s_n_cells)
%     n_cells = s_n_cells(i_cells);
%     rnd_points = zeros(n_cells, 2, numel(s_iterations));
%     mat_file_rnd_points = strcat(mat_suffix, "_rnd_n", num2str(n_cells), ".mat");
%     fprintf("\tsimulating for %i cells (%i/%i)...\n...", n_cells, i_cells, numel(s_n_cells));
%     
%     for i_iteration = 1:numel(s_iterations)
%         iteration = s_iterations(i_iteration);
%         
%         points = simulateMosaic( ...
%             'Roi_Size', s_roi, ...
%             'Soma_Radius', 0, ...
%             'Soma_Radius_std', 0, ...
%             'N_Cells', n_cells, ...
%             'Sampling_Ratio', 1, ...
%             'Receptive_Fields', false);
%         
%         [nnri, ~, er] = computeRegularityIndices(points, [], [s_roi s_roi], [], 'ER_Max', s_roi, 'NN_Max', s_roi);
%         
%         rnd_points(:, :, i_iteration) = points(:, [1 2]);
%         rnd_nnris(i_cells, i_iteration) = nnri.ri;
%         rnd_ers(i_cells, i_iteration) = er.effective_radius;
%         
%         if do_plot
%             showMosaicRegularity(points, [s_roi s_roi], 'NNRI', nnri, 'ER', er, 'RFs', createRFs(points, 50));
%             fullScreen(); pause(); close("all");
%         end
%     end
%     save(mat_file_rnd_points, "rnd_points");
% end
% save(mat_file, "rnd_nnris", "rnd_ers", "-append");
% fprintf("...done\n\n");











