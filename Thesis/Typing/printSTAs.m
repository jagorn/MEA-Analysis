clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')

n_types = numel(symbols);
x_sta = 1:size(temporalSTAs, 2);
side_plots = ceil(sqrt(n_types));
RF_color = [0.3, 0.3, 0.3];

for i_type = 1:n_types
    
    symbol = symbols(i_type);
    name = names(i_type);
    chirp_color = colors(i_type, :);
    id_mosaic = find([mosaicsTable.class] == name);
    
    idx_chirp = mosaicsTable(id_mosaic).indices & ~duplicate_cells;
    idx_RF = mosaicsTable(id_mosaic).controlIndices & ~duplicate_cells;
            
    stas_chirp = temporalSTAs(idx_chirp, :);
    stas_RF = temporalSTAs(idx_RF, :);
    
    stas_chirp = stas_chirp - min(stas_chirp, [], 2);
    stas_RF = stas_RF - min(stas_RF, [], 2);
    
    stas_chirp = stas_chirp ./ max(stas_chirp, [], 2);
    stas_RF = stas_RF ./ max(stas_RF, [], 2);
    
    subplot(side_plots, side_plots, i_type);
    hold on
    plot_std_surface(stas_RF, x_sta, RF_color);
    plot_std_surface(stas_chirp, x_sta, chirp_color);
%     plot(x_sta, mean(stas_chirp), '--', 'Color', chirp_color, 'LineWidth', 2);
    title(symbol);
end