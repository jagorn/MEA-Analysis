close all
clear

load(getDatasetMat, "mosaicsTable", "modelsTable", "controlTable")
load(getDatasetMat(), 'spatialSTAs', 'stas');

y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);
background = ones(y_size, x_size) * 255;

for i = 1:numel(mosaicsTable)
    
    rgc_class = mosaicsTable(i).class;
    cnn_class = mosaicsTable(i).bestModel;
    sta_class = mosaicsTable(i).bestControl;
    experiment = mosaicsTable(i).experiment;
    
    rgc_indices = classExpIndices(rgc_class, experiment);
    cnn_indices = modelsTable( ([modelsTable.class] == cnn_class) & ([modelsTable.experiment] == experiment) ).indices;
    sta_indices = controlTable( ([controlTable.class] == sta_class) & ([controlTable.experiment] == experiment) ).indices;
    
    [rgc_indices, ~] = filterDuplicates(rgc_indices);
    [cnn_indices, ~] = filterDuplicates(cnn_indices);
    [sta_indices, ~] = filterDuplicates(sta_indices);
    
    rgc_rfs = spatialSTAs(rgc_indices);
    cnn_rfs = spatialSTAs(cnn_indices);
    sta_rfs = spatialSTAs(sta_indices);
    
    figure();
    subplot(1, 2, 1)
    
    colormap gray
    image(background);
    hold on
%     
%     for i_rf = 1:size(sta_rfs, 2)
%         [x, y] = boundary(sta_rfs(i_rf));
%         fill(x,y,'g', 'EdgeColor', 'g', 'FaceAlpha', 0.3);
%     end
%     
%     for i_rf = 1:size(rgc_rfs, 2)
%         [x, y] = boundary(rgc_rfs(i_rf));
%         plot(x, y, 'k', 'LineWidth', 3)
%     end
%     
    xlim([(x_size*.2), (x_size*.8)])
    ylim([(y_size*.2), (y_size*.8)])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    daspect([1 1 1])
    title("BASELINE METHOD")
    
    subplot(1, 2, 2)
    
    colormap gray
    image(background);
    hold on
    
%     for i_rf = 1:size(cnn_rfs, 2)
%         [x, y] = boundary(cnn_rfs(i_rf));
%         fill(x,y,'r', 'EdgeColor', 'r', 'FaceAlpha', 0.3);
%     end
    
    for i_rf = 1:size(rgc_rfs, 2)
        [x, y] = boundary(rgc_rfs(i_rf));
        plot(x, y, 'k', 'LineWidth', 3)
    end
    
    xlim([(x_size*.2), (x_size*.8)])
    ylim([(y_size*.2), (y_size*.8)])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    daspect([1 1 1])
    title("DEEP-NET METHOD")

    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1200;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    suptitle(strcat(rgc_class, ' ', experiment))
%     saveas(gcf, strcat('mosaic_', regexprep(rgc_class, '\.', ','), '_', experiment),'jpg')
%     close;
end


