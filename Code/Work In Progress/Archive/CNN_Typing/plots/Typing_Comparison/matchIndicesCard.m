function matchIndicesCard(name1, name2, indices1, indices2, experiments)

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

colors = [.7, .7, .1; .3, .3, .8; .2 .9, .2];
nRows = ceil(numel(experiments) / 3) + 3;

card_title = strcat("comparison between ", name1, " & ", name2);
figure('Name', card_title);

subplot(nRows, 4, [1, 2, 3])
snr = plotPSTH(indices1 & ~indices2, colors(1, :));
title(strcat("FP: only ", name1, " (SNR = ", string(snr), ")"));

subplot(nRows, 4, 4)
plotTSTAs(indices1 & ~indices2, colors(1, :));

subplot(nRows, 4, [5, 6, 7])
snr = plotPSTH(indices1 & indices2, colors(3, :));
if isnan(snr) 
    snr = 0;
end
title(strcat("TP: ", name1, " & ", name2, " (SNR = ", string(snr), ")"));

subplot(nRows, 4, 8)
plotTSTAs(indices1 & indices2, colors(3, :));

subplot(nRows, 4, [9, 10, 11])
snr = plotPSTH(~indices1 & indices2, colors(2, :));
title(strcat("TN: only ", name2, " (SNR = ", string(snr), ")"));

subplot(nRows, 4, 12)
plotTSTAs(~indices1 & indices2, colors(2, :));


for iExp = 1:numel(experiments)
    exp_indices1 = expIndices(experiments{iExp}) & indices1;
    exp_indices2 = expIndices(experiments{iExp}) & indices2;
    
    i_plot = iExp + 3*3;
    subplot(nRows, 3, i_plot);
    matchSSTAs(exp_indices1, exp_indices2, colors);
    title(experiments{iExp}, "Interpreter", "none")
end

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 400 * nRows;
horz = 1000;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);