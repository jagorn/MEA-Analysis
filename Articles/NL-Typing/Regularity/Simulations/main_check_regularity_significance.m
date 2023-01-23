clear;
close all;
clc;

% params
p.s_roi = 500;
p.s_n_cells = 5:2:15;
p.s_radii = [50 65 80];
p.s_noises = [5 10 15];
p.s_iterations = 1:100;
percentile_x = 95;
 
% load
ri_mat_file = '/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/regularity_test/regularity_test.mat';
load(ri_mat_file, 'good_ers', 'good_nnris', 'rnd_ers', 'rnd_nnris');

rnd_ers_sorted = sort(rnd_ers, 2);
rnd_nnris_sorted = sort(rnd_nnris, 2);

ers_null_significant_percentile = rnd_ers_sorted(:, percentile_x);
nnris_null_significant_percentile = rnd_nnris_sorted(:, percentile_x);

[n_sizes, n_radii, n_noises, n_iterations] = size(good_ers);

average_ers  = zeros(n_sizes, n_radii, n_noises);
average_nnris = zeros(n_sizes, n_radii, n_noises);

ers_significance_percentage = zeros(n_sizes, n_radii, n_noises);
nnris_significance_percentage = zeros(n_sizes, n_radii, n_noises);
total_significance_percentage = zeros(n_sizes, n_radii, n_noises);

for i_sizes = 1:n_sizes
    for i_radii = 1:n_radii
        for i_noises = 1:n_noises
            
            n_cells = p.s_n_cells(i_sizes);
            radius = p.s_n_cells(i_radii);
            noise = p.s_n_cells(i_noises);
            
            ers = good_ers(i_sizes, i_radii, i_noises, :);
            nnris = good_nnris(i_sizes, i_radii, i_noises, :);
            
            valid_mosaics = ~isnan(ers);
            valid_ers = ers(valid_mosaics);
            valid_nnris = nnris(valid_mosaics);
            
            if sum(valid_mosaics) > 50
                average_ers(i_sizes, i_radii, i_noises) = mean(valid_ers);
                average_nnris(i_sizes, i_radii, i_noises) = mean(valid_nnris);
                
                significant_ers = valid_ers >= ers_null_significant_percentile(i_sizes);
                significant_nnris = valid_nnris >= nnris_null_significant_percentile(i_sizes);
                
                ers_significance_percentage(i_sizes, i_radii, i_noises) = sum(significant_ers) / sum(valid_mosaics);
                nnris_significance_percentage(i_sizes, i_radii, i_noises) = sum(significant_nnris) / sum(valid_mosaics);
                total_significance_percentage(i_sizes, i_radii, i_noises) = sum(significant_ers & significant_nnris) / sum(valid_mosaics);
            else
                average_ers(i_sizes, i_radii, i_noises) = nan;
                average_nnris(i_sizes, i_radii, i_noises) = nan;
                ers_significance_percentage(i_sizes, i_radii, i_noises) = nan;
                nnris_significance_percentage(i_sizes, i_radii, i_noises) = nan;
                total_significance_percentage(i_sizes, i_radii, i_noises) = nan;
            end
        end
    end  
end

plot_regularity_index(average_ers, p);
xlabel("Mosaic Size [a.u.]");
ylabel("Mean Effective-Radius");
title("Mean Effective-Radius");

plot_regularity_index(average_nnris, p);
xlabel("Mosaic Size [a.u.]");
ylabel("Mean Nearest Neighbour Regularity Index");
title("Mean Nearest Neighbour Regularity Index");

plot_regularity_index(ers_significance_percentage, p);
xlabel("Mosaic Size [a.u.]");
ylabel("Significance Probability [%]");
ylim([-0.1, 1.1]);
title("Effective-Radius Significance");

plot_regularity_index(nnris_significance_percentage, p);
xlabel("Mosaic Size [a.u.]");
ylabel("Significance Probability [%]");
ylim([-0.1, 1.1]);
title("Nearest Neighbour Regularity Index Significance");

plot_regularity_index(total_significance_percentage, p);
xlabel("Mosaic Size [a.u.]");
ylabel("Significance Probability [%]");
ylim([-0.1, 1.1]);
title("Joint Test Significance");

function plot_regularity_index(regularity_mat, p)

    [n_sizes, n_radii, n_noises] = size(regularity_mat);
    x = p.s_n_cells;
    colors = [0.8, 0.1, 0.1, 0.8; 0.1, 0.1, 0.8, 0.8; 0.1, 0.8, 0.1, 0.8;];
    lines = ["-", "--", "-."];
    
    figure();
    hold on;
    
    for i_radii = 1:n_radii
        color = colors(i_radii, :);
        radius = p.s_radii(i_radii);
        
        for i_noises = 1:n_noises 
            line = lines(i_noises);
            noise = p.s_noises(i_noises);

            y = regularity_mat(:, i_radii, i_noises);
            x_plot = x(~isnan(y));
            y_plot = y(~isnan(y));
            legend_txt = strcat("r=", num2str(radius), ", \sigma=", num2str(noise));
            plot(x_plot, y_plot, line, 'Color', color, 'DisplayName', legend_txt, 'LineWidth', 2);
        end
    end
    
    xticks(p.s_n_cells);
    legend('Location', 'SouthEast');
end