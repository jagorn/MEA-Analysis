clear
close all

model_label = 'LNP';
exp_id = '20191011_grid';
dh_session = 3;
mea_channels = [1:126, 129:254]; % excluded trigger electrodes
elec_radius = 30;

output_folder = [dataPath '/' exp_id '/processed/DH/Plots/MUA_ReceptiveFields'];
load([dataPath '/' exp_id '/processed/DH/models/' 'dh' num2str(dh_session) '_models.mat'], 'dh_models');
load([dataPath '/' exp_id '/processed/DH/' 'DH_' num2str(dh_session) '.mat'], 'dh');
load([dataPath '/' exp_id '/processed/DH/' 'DHCoords.mat'], 'PatternCoords_MEA');

accuracies = dh_models.(model_label).accuracies;
good_elecs = accuracies > 0.6;


plotMEA()
plotGridMEA()

mea_map = getMapMEA();
mea_positions = mea_map(mea_channels, :);
cmap = colormap();
color_indices = ceil(accuracies * size(cmap, 1));
color_indices(isnan(color_indices)) = [];
colors = cmap(color_indices, :);

scatter(mea_positions(:, 1), mea_positions(:, 2), 1000, colors, 'filled');
cbar = colorbar;
cbar.Label.String = 'Model Accuracy (Pearson Correlation Coefficient)';
title('Performance of Max-Likelihood Fitting on MUA responses to DH spots')

plot_name = ['dh' num2str(dh_session) '_fitting_accuracy'];
saveas(gcf, [tmpPath '/' plot_name],'jpg');
movefile([tmpPath '/' plot_name '.jpg'], output_folder);
close;

x_spots = PatternCoords_MEA(:, 1)/elec_radius;
y_spots = PatternCoords_MEA(:, 2)/elec_radius;

% Do
for i_elec = find(good_elecs)'
       
    plotMEA()
    rectangle('Position', [0.5, 0.5, 16, 16],'FaceColor', [0.4, 0.4, 0.4], 'LineStyle', 'none');
    plotGridMEA()
    plotElectrodeMEA(mea_map(i_elec,:), 'yellow')
    
    weights = dh_models.(model_label).ws(i_elec,:);
    w = weights / max(abs(weights));
    
    colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
    colormap(colorMap);

    spot_plot = scatter(x_spots, y_spots, 500, w, 'Filled');
    
    cbar = colorbar;
    caxis([-1 +1])
    cbar.Label.String = 'Receptive Field Values';
    title(['Receptive Field of Electrode #' num2str(i_elec) ' forHolographic Stimulation'])

    plot_name = ['dh' num2str(dh_session) '_rf' num2str(i_elec)];
    saveas(gcf, [tmpPath '/' plot_name],'jpg');
    movefile([tmpPath '/' plot_name '.jpg'], output_folder);
    close;
end