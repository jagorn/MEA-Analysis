function regularity = checkMosaicRegularity(mosaics, rfs, roi, varargin)


% Parameters
sparse_threshold_def = [];
debug_def = false;
regularity_def = [];
mosaic_idx_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'mosaics');
addRequired(p, 'rfs');
addRequired(p, 'roi');
addParameter(p, 'Sparseness_Threshold', sparse_threshold_def);
addParameter(p, 'Add_To_Regularities', regularity_def);
addParameter(p, 'Mosaic_Idx', mosaic_idx_def);
addParameter(p, 'Debug', debug_def);

parse(p, mosaics, rfs, roi, varargin{:});
sparse_threshold = p.Results.Sparseness_Threshold;
regularity = p.Results.Add_To_Regularities;
mosaic_idx = p.Results.Mosaic_Idx;
debug = p.Results.Debug;

if isempty(regularity)
    clear regularity
    regularity(numel(mosaics)) = struct();
end

if isempty(mosaic_idx)
    mosaic_idx = 1:numel(mosaics);
end

for i_mosaic = mosaic_idx
    mosaic = mosaics(i_mosaic);
    fprintf("\nmosaic #%i: %s %s\n", i_mosaic, mosaic.type, mosaic.experiment);
    
%     try
        mosaic_rfs = rfs(mosaic.idx);
        [somas_x, somas_y] = centroid(mosaic_rfs);
        mosaic_somas = [somas_x; somas_y]';
        
        [voronoi, triangles, voronoi_cells] = computeSparseVoronoi(mosaic_somas, roi, 'Sparseness_Threshold', sparse_threshold);
        ci  = OptimizeCoverageSize(mosaic_rfs, roi, 'Debug', debug);
        [nnri, vvri, er] = computeRegularityIndices(mosaic_somas, mosaic_rfs, roi, voronoi);
        
        regularity(i_mosaic).voronoi_cells = voronoi_cells;
        regularity(i_mosaic).voronoi = voronoi;
        regularity(i_mosaic).triangles = triangles;
        regularity(i_mosaic).nnri = nnri;
        regularity(i_mosaic).vvri = vvri;
        regularity(i_mosaic).er = er;
        regularity(i_mosaic).ci = ci;
        fprintf("Mosaic %s %s parsed succesfully\n", mosaic.type, mosaic.experiment);
        
%     catch error
%         fprintf("Mosaic %s %s could not be parsed: %s\n", mosaic.type, mosaic.experiment, error.message);
%     end
    if debug
        showMosaicRegularity(mosaic.somas, roi, ...
            'Voronoi_Cells', voronoi_cells, ...
            'RFs', ci.rfs_opt, ...
            'Voronoi', voronoi, ...
            'NNRI', nnri, ...
            'VVRI', vvri, ...
            'ER', er);
        pause();
        close all;
    end
end