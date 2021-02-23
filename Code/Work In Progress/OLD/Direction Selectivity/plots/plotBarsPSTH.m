function length = plotBarsPSTH(barsPSTH, tBin)

[length, nDirections] = size(barsPSTH);
for iDirections = 1:nDirections
    plot(barsPSTH(:, iDirections));
    hold on
end

hold off
xlim([0 length + length/5])
ylim([-.2 1.2])
pbaspect([1 1 1]);

yticks([-1 0 1])
xticks([0, length/2, length]);
xticklabels([0, length/2, length] * tBin);

title('Normalized Bars Response');