clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat');
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/20181018b.mat', 'euler', 'euler_freq');

% Euler
euler_cropped = cropEuler(euler, euler_freq);
euler_plot = 256 - euler_cropped;
x_euler = 0:(1/euler_freq):((numel(euler_plot)-1)/euler_freq);
t_bin_psth = 0.05;

% Responses
i_classes = 0;
for i = 1:numel(classesTableNotPruned)
    
    if any(strcmp(classesTableNotPruned(i).name, [mosaicsTable.class]))
        i_classes = i_classes + 1;
        psths_plot(i_classes, :) = classesTableNotPruned(i).PSTH / max(classesTableNotPruned(i).PSTH);
        stas_plot(i_classes, :) = classesTableNotPruned(i).STA;
        names_plot(i_classes) = classesTableNotPruned(i).name;
    end
end
symbols = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "0"];
x_psth = 0:t_bin_psth:((numel(psths_plot(1, :))-1)*t_bin_psth);
n_classes = i_classes;

% sort
sust2trans = sum(psths_plot, 2);
on2off = abs(max(stas_plot, [], 2)) < abs(min(stas_plot, [], 2));

[~, idx_sust2trans] = sort(sust2trans);
[~, idx_on_off] = sort(on2off(idx_sust2trans));
idx_plot = idx_sust2trans(idx_on_off);

% Plot STIMULI
figure();

subplot(n_classes + 1, 7, 1:6);
plot(x_euler, euler_plot, 'k', 'LineWidth', 1);
xlim([min(x_euler), max(x_euler)])
axis off;

subplot(n_classes + 1, 7, 7);
image([.95, .25; .25, .95]*256)
colormap('gray');
axis off;
pbaspect([1 1 1])


% Plot Responses
colors = get_sorted_colors(n_classes);
names = names_plot(idx_plot);
psths = psths_plot(idx_plot, :);
stas = stas_plot(idx_plot, :);

for i = 1:n_classes
    
    i_cell = idx_plot(i);
    psth = psths_plot(i_cell, :);
    sta = stas_plot(i_cell, :);
    
    color = colors(i, :);
    subplot(n_classes + 1, 7, 7 * i + (1:6));
    plot_surface_psth(x_psth, psth, color)
    xlim([min(x_psth), max(x_psth)]);
    yticks([]);
    xticks([]);
    axis off
    
    text(-1, 0.5, symbols(i), 'FontWeight', 'bold');
    if i == 1
        hold on
        plot([0.5, 2.5], [1, 1], 'k', 'LineWidth', 1.5);
        text(1.5, 1, '2s','HorizontalAlignment','left', 'VerticalAlignment', 'top')
    end
    
    subplot(n_classes + 1, 7, 7 * i + 7);
    plot(sta, 'Color', color, 'LineWidth', 1.5);
    axis off
end


ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 1000;
horz = 500;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);


save('typing_colors.mat', 'names', 'colors', 'symbols', 'psths', 'stas', 'x_psth');


function colors = get_sorted_colors(n_colors)
hsvs = ones(n_colors, 3);
hsvs(:, 1) = linspace(0, 0.9, n_colors);
hsvs(:, 3) = hsvs(:, 3) * 0.8;

colors = hsv2rgb(hsvs);
end

function p = plot_surface_psth(x, y, color)
x_plot = [x, fliplr(x)];
y_plot = [y, zeros(size(y))];

x_plot(isnan(y_plot)) = [];
y_plot(isnan(y_plot)) = [];

fill(x_plot, y_plot, color, 'EdgeColor', 'None');
yline(0, 'Color', color, 'LineWidth', 1);
end

