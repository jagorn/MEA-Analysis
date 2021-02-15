function plotMeanFeaturePSTHs(logicalIndices)

load(getDatasetMat, 'features_psths');

traces = features_psths(logicalIndices, :);
avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = avgTrace + stdTrace / 2;
downSTD = avgTrace - stdTrace / 2;
avgSTD = mean(stdTrace);

% Plot Standard Deviation
x = 1:length(avgTrace);
x2 = [x, fliplr(x)];
inBetween = [upSTD, fliplr(downSTD)];
fill(x2, inBetween, [0.75, 0.75, 0.75]);
hold on
 
% Plot Mean
plot(avgTrace, 'r', 'LineWidth', 3)
xticks([])
yticks([])

if isnan(avgSTD) || avgSTD == 0
    title("Mean Feature PSTH")
else
    title(strcat("Mean Feature PSTH (avg STD = ", num2str(avgSTD), ")"))
end

