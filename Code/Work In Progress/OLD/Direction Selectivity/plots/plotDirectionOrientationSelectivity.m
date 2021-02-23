function plotDirectionSelectivity(dsK, dsAngle, osK, osAngle, dirModules)

directions = [0, pi* 1/4, pi* 1/2, pi* 3/4, pi, pi* 5/4, pi* 3/2, pi* 7/4];
plotAngles = [directions, directions(1)];
plotMods = [dirModules, dirModules(1)];

% if  min(plotMods) < 0 
%     plotMods = plotMods -  min(plotMods);
% end

% polarplot(plotAngles, plotMods, 'k', 'LineWidth', 7);
polarplot(plotAngles, plotMods, 'LineWidth', 1.5);
hold on

polarplot([osAngle, osAngle + pi], [osK/ 2, osK/ 2], 'g-.', 'LineWidth', 1.8);
polarplot([0, dsAngle], [0, dsK], 'r', 'LineWidth', 1.8);
% polarscatter(0,0, 'filled', 'k', 'LineWidth', 3);
hold off

txt1 = strcat('K_d = ', num2str(dsK), '   \alpha_d = ', num2str(dsAngle), 'rads');
txt2 = strcat('K_o = ', num2str(osK), '   \alpha_o = ', num2str(osAngle), 'rads');
text(5/4*pi,1.2,{txt1, txt2});

thetaticks(0:45:315);
thetaticklabels([]);
rticklabels([]);
rlim([0 1])
rticks([0, 0.25, .5, .75, 1.0])

% 
% pax = gca;
% pax.LineWidth = 5;
% pax.GridColor = [0.1, 0.1, 0.1];


