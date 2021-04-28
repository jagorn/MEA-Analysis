clear
close all
clc

load(getDatasetMat, "classesTable");
typeIDs = getLeafClasses();
colors = getColors(numel(typeIDs));

figure()
on_idx = find([classesTable.POLARITY] == "ON");
off_idx = find([classesTable.POLARITY] == "OFF");

i_plot = 1;

for i_cell = on_idx
subplot(numel(typeIDs), 5, [i_plot, i_plot + 3])
plot(classesTable(i_cell).PSTH, 'Color', colors(i_cell, :), 'LineWidth', 1.5)
i_plot = i_plot + 4;
axis off
% title(classesTable(i_cell).name)

subplot(numel(typeIDs), 5, i_plot)
plot(classesTable(i_cell).STA, 'Color', colors(i_cell, :), 'LineWidth', 1.5)
i_plot = i_plot + 1;
axis off
% title(classesTable(i_cell).name)
end

for i_cell = off_idx
subplot(numel(typeIDs), 5, [i_plot, i_plot + 3])
plot(classesTable(i_cell).PSTH, 'Color', colors(i_cell, :), 'LineWidth', 1.5)
i_plot = i_plot + 4;
axis off
% title(classesTable(i_cell).name)

subplot(numel(typeIDs), 5, i_plot)
plot(classesTable(i_cell).STA, 'Color', colors(i_cell, :), 'LineWidth', 1.5)
i_plot = i_plot + 1;
axis off
% title(classesTable(i_cell).name)

end
