function rf_mask = computeMosaicMask(sSTAs, w, h)

rf_mask = false;
for ellipse = sSTAs
    [x, y] = boundary(ellipse);
    mask = poly2mask(x, y, h, w);
    rf_mask = rf_mask | mask;
end
