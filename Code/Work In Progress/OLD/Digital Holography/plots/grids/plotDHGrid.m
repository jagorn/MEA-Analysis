function plotDHGrid(nx, ny)

figure()

xlim([0.5, nx + 0.5]);
ylim([0.5, ny + 0.5]);

xticks(1:nx)
yticks(1:ny)

xline(0.5);
xline(nx + 0.5);
yline(0.5);
yline(ny + 0.5);

xlabel('Columns')
ylabel('Rows')
title('DH Spots Grid')
hold on

for i_line = 0.5:(nx + 0.5)
    xline(i_line, 'Color', [.4, .4, .4], 'LineWidth', 1.5);
end

for i_line = 0.5:(ny + 0.5)
    yline(i_line, 'Color', [.4, .4, .4], 'LineWidth', 1.5);
end


