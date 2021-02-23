close all
clear

load(getDatasetMat, "mosaicsTable")
load(getDatasetMat(), 'psths', 'params')
load(getDatasetMat(), 'temporalSTAs', 'spatialSTAs', 'stas');

classes = [mosaicsTable.class];
experiments = [mosaicsTable.experiment];
tBin = params.psth.tBin;

y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);
    
for i = 1:numel(classes)
    class = classes(i);
    experiment = experiments(i);
    idx = and(classIndices(class), expIndices(experiment));
    [indices, ~] = filterDuplicates(idx);

    figure();
    
    subplot(3, 3, [7 8 9])

    traces = psths(indices, :);
    traces = traces ./ max(traces, [], 2);
    avgTrace = mean(traces, 1);

    xs = cumsum(ones(1, length(avgTrace)) * tBin);
    plot(xs, avgTrace, 'k', 'LineWidth', 1)
    xlim([0, xs(end)]);
    ylim([-0.1, +1.1]);


    subplot(3, 3, 6)

    tSTA = temporalSTAs(indices, :);
    tSTA = tSTA - mean(tSTA, 2);
    tSTA = tSTA ./ std(tSTA, [], 2);
    tSTA = tSTA + mean(tSTA, 2);

    plot(mean(tSTA, 1), 'k', "LineWidth", 1.5)

    xlim([1, size(tSTA ,2)]);
    ylim([-4, 4]);


    subplot(3, 3, [1 2 4 5])
    rfs = spatialSTAs(indices);
    hold on
    for i_rf = 1:size(rfs, 2)  
        [x, y] = boundary(rfs(i_rf));
        plot(x, y, 'k', 'LineWidth', 1.5)
    end

    xlim([(x_size*.2), (x_size*.8)])
    ylim([(y_size*.2), (y_size*.8)])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    daspect([1 1 1])

    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 600;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);  
end


