function plotTSTAs(indices, color)
% Plots the temporal component of the STA of a set of cells
%
% Parameters;
% indices:                     the id numbers of the cells
% colors (optional):           colors of the traces


load(getDatasetMat(), 'temporalSTAs')

if exist("color", "var")
    colors = repmat(color, sum(indices>0), 1);
else
    colors = getColors(sum(indices>0));
end

tSTA = temporalSTAs(indices, :);
tSTA = tSTA - mean(tSTA, 2);
tSTA = tSTA ./ std(tSTA, [], 2);
tSTA = tSTA + mean(tSTA, 2);

for i=1:size(tSTA, 1)
    plot(tSTA(i, :), "Color", colors(i, :), "LineWidth", 1.5)
    hold on
end

xlim([1, size(tSTA ,2)]);
ylim([-4, 4]);

if numel(indices) == 1
    title(strcat("Cell #", num2str(indices), ": t-STA"))
    
else
    snr = doSNR(tSTA);
    title(strcat("Average t-STAs (SNR = ", num2str(snr), ")"))
end