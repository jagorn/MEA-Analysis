function rf_coverage = computeMosaicCoverage(exp_mask, rfs)

rf_coverage = exp_mask - 1;
for rf = rfs
    [x, y] = boundary(rf);
    mask = poly2mask(x, y, size(exp_mask, 1), size(exp_mask, 2));
    rf_coverage = rf_coverage + mask;
end