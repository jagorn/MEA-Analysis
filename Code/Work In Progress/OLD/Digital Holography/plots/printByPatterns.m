idx_patterns = 1:36;

for i_p = idx_patterns
    plotDHRaster_by_pattern(i_p, 'DHSingle', 'single')
    export_fig([plotsPath() '/' getDatasetId() '/' 'DHSingle_rasters_pattern#' num2str(i_p)], '-svg')
    close;
end