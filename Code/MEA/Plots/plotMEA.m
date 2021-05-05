function plotMEA()
% Plots a 16 * 16 space representing a Multi Electrode Array

figure()

ax1 = axes();

xlim([0.5,16.5]);
ylim([0.5,16.5]);

xticks(1:16)
yticks(1:16)

xline(0.5);
xline(16.5);
yline(0.5);
yline(16.5);

xlabel('Electrode Indices (Columns)')
ylabel('Electrode Indices (Rows)')
title('Multi Electrode Array')
hold on

fullScreen();

