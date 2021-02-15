function plotSetFeatures(indices)

load(getDatasetMat, 'clustersTable');

set_Ns = {clustersTable(indices).N};
set_Exps = {clustersTable(indices).Experiment};

nCols = 1;
nRows = 10;

for iColPlot = 1:nCols
    for iRowPlot = 1:nRows
        iPlot = iRowPlot + nRows * (iColPlot-1);
        nCells = numel(set_Ns);
        if iPlot <= nCells
            subplot(nRows + 1, nCols, iPlot + 1)

            plotFeaturePSTHs(set_Exps{iPlot}, set_Ns{iPlot});
            plotTitle = strcat('#', int2str(set_Ns{iPlot}),' Exp. ', set_Exps{iPlot});
            title(plotTitle);
        end
    end
end

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 800;
horz = 1600;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
