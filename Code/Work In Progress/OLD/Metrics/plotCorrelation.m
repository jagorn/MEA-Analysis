function plotCorrelation(x, y, x_label, y_label)

assert(numel(x) == numel(y));

hold on
scatter(x, y, 15, 'r', 'filled', 'o');
text(x, y, string(1:length(x)))

plot([0, 1], [0, 1], "LineWidth", 1.5, "Color", [.2, .2, .2])
% xlim([0, 1])
% ylim([0, 1])

xlabel(x_label);
ylabel(y_label);
title("Correlation");