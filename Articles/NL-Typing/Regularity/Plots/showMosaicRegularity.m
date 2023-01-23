function showMosaicRegularity(cells, roi, varargin)

% Parameters
voronoi_cells_def = false(size(cells, 1), 1);
rfs_def = [];
voronoi_def = [];
delaunay_def = [];
nnri_def = [];
vvri_def = [];
er_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'cells');
addRequired(p, 'roi');
addParameter(p, 'Voronoi_Cells', voronoi_cells_def);
addParameter(p, 'RFs', rfs_def);
addParameter(p, 'Voronoi', voronoi_def);
addParameter(p, 'Delaunay', delaunay_def);
addParameter(p, 'NNRI', nnri_def);
addParameter(p, 'VVRI', vvri_def);
addParameter(p, 'ER', er_def);

parse(p, cells, roi, varargin{:});
rfs = p.Results.RFs;
voronoi_cells = p.Results.Voronoi_Cells;
voronoi = p.Results.Voronoi;
delaunay = p.Results.Delaunay;
nnri = p.Results.NNRI;
vvri = p.Results.VVRI;
er = p.Results.ER;

figure();

if isempty(nnri) && isempty(vvri) && isempty(er)
    plotMosaic(cells, roi, ...
        'Voronoi', voronoi, ...
        'Delaunay', delaunay, ...
        'Voronoi_Cells', voronoi_cells, ...
        'RFs', rfs);
    
    title('RGC Mosaic');
    
else
    subplot(1, 2, 1);
    plotMosaic(cells, roi, ...
        'Voronoi', voronoi, ...
        'Delaunay', delaunay, ...
        'Voronoi_Cells', voronoi_cells, ...
        'RFs', rfs);
    
    title('RGC Mosaic');
    
    subplot(2, 4, 3);
    plotRI(nnri);
    title('Nearest Neighbour Distances');
    
    if ~isempty(vvri)
        subplot(2, 4, 4);
        plotRI(vvri);
        title('Voronoi Areas');
    end
    
    subplot(2, 4, 7);
    plotCorrelogram(er);
    title('Auto-Correlogram');
    
    subplot(2, 4, 8);
    plotDensityProfile(er)
    title('Density Profile');
end