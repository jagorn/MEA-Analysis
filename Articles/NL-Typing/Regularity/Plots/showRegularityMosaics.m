function showRegularityMosaics(rfs, mosaics, regularities, roi)
for i_r = 1:numel(regularities)
    
    r = regularities(i_r);
    m = mosaics(i_r);
    [somas_x, somas_y] = centroid(rfs(m.idx));
    m_somas =  [somas_x; somas_y]';
    
    plotRFCoverage(r.ci);
    title(m.id);
    
    showMosaicRegularity(m_somas, roi, ...
        'Voronoi_Cells', r.voronoi_cells, ...
        'RFs', r.ci.rfs_opt, ...
        'Voronoi', r.voronoi, ...
        'NNRI', r.nnri, ...
        'VVRI', r.vvri, ...
        'ER', r.er);
    title(m.id);
    
    pause();
    close all;
end