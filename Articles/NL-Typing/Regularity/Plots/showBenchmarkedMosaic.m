function showBenchmarkedMosaic(cells, roi, r, b)

voronoi_cells = r.voronoi_cells;
voronoi = r.voronoi;
nnri = r.nnri;
er = r.er;
ci = r.ci;

figure();


subplot(1, 2, 1);
plotMosaic(cells, roi, ...
    'RFs', r.ci.rfs);

title('RGC Mosaic');

subplot(2, 4, 3);
plotRI(nnri, b);
title('Nearest Neighbour Distances');

subplot(2, 4, 4);
plotDensityProfile(er, b)
title('Density Profile');


b_nnris = zeros(numel(b), 1);
b_ers = zeros(numel(b), 1);
b_cis = zeros(numel(b), 1);
b_pfs = zeros(numel(b), 1);
for i_b = 1:numel(b)
    b_nnris(i_b) = b(i_b).nnri.ri;
    b_ers(i_b) = b(i_b).er.effective_radius;
    b_cis(i_b) = b(i_b).ci.cov_index;
    b_pfs(i_b) = b(i_b).er.packing_factor;
end


subplot(2, 8, 13);
plotBenchmarkedBar(nnri.ri, b_nnris, [0.6 0.1 0.1]);
title('N.N. R.I.');


subplot(2, 8, 14);
plotBenchmarkedBar(er.effective_radius, b_ers, [0.1 0.1 0.6]);
title('E.R.');

subplot(2, 8, 15);
plotBenchmarkedBar(ci.cov_index, b_cis, [0.1 0.6 0.1]);
title('C.I.');

subplot(2, 8, 16);
plotBenchmarkedBar(er.packing_factor, b_pfs, [0.4 0.1 0.4]);
title('P.F.');