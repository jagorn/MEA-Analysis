function plotCoverageHisto(coverage)

coverage_sat = min(coverage, 3);
coverage_definite = coverage_sat(coverage_sat >= 0);
histogram(coverage_definite, -0.5:1:+3.5, 'Normalization', 'probability', 'FaceColor', 'r');
ylim([0 1.1]);
xticks([0,1,2,3])
xticklabels({'0','1','2','3+'})
xlabel('number of RFs on a pixel')
ylabel('frequency')
title('Overlaps in RFs mosaic')
