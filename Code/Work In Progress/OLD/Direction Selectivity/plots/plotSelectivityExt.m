function plotSelectivityExt(dsK, dsAngle, osK, osAngle, dirModules, barsPSTH, barsPSTH_l, barsPSTH_r, tBin)

figure()

subplot(3,3,1);
plotBarsPSTH(barsPSTH(:, 4), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 4), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 4), tBin);

subplot(3,3,2);
plotBarsPSTH(barsPSTH(:, 3), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 3), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 3), tBin);

subplot(3,3,3);
plotBarsPSTH(barsPSTH(:, 2), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 2), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 2), tBin);

subplot(3,3,4);
plotBarsPSTH(barsPSTH(:, 5), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 5), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 5), tBin);

subplot(3,3,5);
plotDirectionSelectivity(dsK, dsAngle, osK, osAngle, dirModules)

subplot(3,3,6);
plotBarsPSTH(barsPSTH(:, 1), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 1), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 1), tBin);

subplot(3,3,7);
plotBarsPSTH(barsPSTH(:, 6), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 6), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 6), tBin);

subplot(3,3,8);
plotBarsPSTH(barsPSTH(:, 7), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 7), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 7), tBin);

subplot(3,3,9);
plotBarsPSTH(barsPSTH(:, 8), tBin);
hold on
plotBarsPSTH(barsPSTH_l(:, 8), tBin);
hold on
plotBarsPSTH(barsPSTH_r(:, 8), tBin);


ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 900;
horz = 900;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);