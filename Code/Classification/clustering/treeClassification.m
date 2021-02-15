function [clustersTable, classTree, PCAs, clusters_params] = treeClassification(cellsTable, features_matrix, features_psths, t_stas, varargin)

% ALGORITHM FOR UNSUPERVISED RECURSIVE CLASSIFICATION OF RGCs
% The population of cells is subdivided in clusters recursively.
% Preliminary classifications are accepted as input.
% Each of the provided classes of cells is subdivided recursively.

% If no prelinimary classes are provided, all cells will be considered
% and clustered together.

% If preliminary classes are provided, only cells belonging to the
% preliminary classes will be clustered, and each class will be clustered
% independently.

% The data is retrieved from the cellsTable struct. (see buildDatasetTable)


% REQUIRED PARAMETERS:
% cellsTable:       a struct with indexes and experiment of all the cells. 
%                   (see buildDatasetTable).
% features_matrix:  a matrix of feature vectors.
%                   they are used to clusterize the data (n_cells*n_feats).
% features_psths:   a matrix of psths to a characteristic fullfield stimulus.
%                   they are used for cluster validation (n_cells*n_tsteps).
% t_stas:           the temporal components of the cell stas.
%                   they are used for cluster validation (n_cells*n_tsteps).

% OPTIONAL PARAMETERS:
% parameters:       a struct with all the parameters used for classification
%                   (see the section DEFAULT PARAMETERS below);
%                   if parameters are not provided, default values will be used.
% labels2cells:     the prelinimary classes [map: label (string) 2 logical indices]
% labelsToCluster:  the classes NOT PRESENT in this list are considered
%                   FINAL and hence will not be subclustered [list: labels (string)]

% OUTPUTS:
% clustersTable:    A table indicating the relationship cells to clusters.
% classTree:        The tree of clusters and subclusters.
% PCAs:             The Principal Component Coefficients of each cell.
% clusters_params:  The parameters used.

% Parse Input
p = inputParser;
addRequired(p, 'cellsTable');
addRequired(p, 'features_matrix');
addRequired(p, 'features_psths');
addRequired(p, 't_stas');
addParameter(p, 'Parameters', []);
addParameter(p, 'Labels2Cells', []);
addParameter(p, 'Labels2Clusters', []);

parse(p, cellsTable, features_matrix, features_psths, t_stas, varargin{:});

clusters_params = p.Results.Parameters;
labels2cells = p.Results.Labels2Cells;
labelsToCluster = p.Results.Labels2Clusters; 


% global parameters
global nIterations;
global nPcaComponents;
global nMaxBranchings;

global cluster_min_size;
global cluster_min_psthSNR;
global cluster_min_staSNR;
global cluster_split_size;
global cluster_split_psthSNR;
global cluster_split_staSNR;

% global features
global refFeatures;
global features;
global cluster_stas;
global cluster_psths;

% global structures
global clustersTable;
global PCAs;


%-------------------------- PARAMETERS ----------------------------------%

if isempty(clusters_params)
    
    % DEFAULT PARAMETERS
    clusters_params.min_size = 4;
    clusters_params.split_size = 6;
    
    clusters_params.min_psth_SNR = .6;
    clusters_params.min_sta_SNR = .9;
    
    clusters_params.split_psth_SNR = .825;
    clusters_params.split_sta_SNR = .95; 
    
    clusters_params.n_iterations = 3;
    clusters_params.nPCA_Components = [10, 10, 10];
    clusters_params.nMaxBranching = [24, 8, 8];
    
    clusters_params.first_iteration_only_STAs = false;
end

% preliminary classification
refFeatures = features_matrix;
refNPcaComponents = 10;

% recursive classification
nIterations = clusters_params.n_iterations;
nPcaComponents = clusters_params.nPCA_Components;
nMaxBranchings = clusters_params.nMaxBranching;

% admissibility check
cluster_min_size = clusters_params.min_size;
cluster_min_psthSNR = clusters_params.min_psth_SNR;
cluster_min_staSNR =  clusters_params.min_sta_SNR;

% splittability check
cluster_split_size = clusters_params.split_size;
cluster_split_psthSNR = clusters_params.split_psth_SNR;
cluster_split_staSNR = clusters_params.split_sta_SNR;

% features
cluster_stas = t_stas;
cluster_psths = features_psths;

features = cell(1, nIterations);
for i_feat = 1:nIterations
    features{i_feat} = features_matrix;
end
if clusters_params.first_iteration_only_STAs
    features{1} = t_stas;
end


%-----------------------------STRUCTURES---------------------------------%

nCells = numel(cellsTable);

% Initialize structure to store the type code of each cell
clustersTable = struct( 'Experiment', {cellsTable.experiment}, ...
                        'N', {cellsTable.N}, ...
                        'Type', cell(1, nCells), ...
                        'Prob', cell(1, nCells)  );
            
% Initialize structure with all the different Principal Component Reductions for each cells
PCAs = struct(  'lvl1', cell(nCells,1), ...
                'lvl2', cell(nCells,1), ...
                'lvl3', cell(nCells,1));
            
            
%------------------------INITIALIZE TABLES-------------------------------%

if isempty(labels2cells)
    labels2cells = containers.Map;
    labels2cells('RGC') = logical(1:numel(cellsTable));
end

if isempty(labelsToCluster)
    labelsToCluster = keys(labels2cells);
end

% Initialize the clusters Table
for label_struct = keys(labels2cells)
    label = cell2mat(label_struct);
    cIndices = find(labels2cells(label));
    cName = string(label);
    for cIndex = cIndices
        clustersTable(cIndex).Type = strcat(cName, ".");
    end
end

% Choose which types to clusterize
nClasses = numel(labelsToCluster);
classesLogicals = cell(nClasses, 1);
for i = 1:nClasses
    label = cell2mat(labelsToCluster(i));
    classLogicals = labels2cells(label);
    classesLogicals(i) = {classLogicals};
end


%-------------------------DO CLUSTERING----------------------------------%

% Do PCA on the whole dataset.
% This is only needed to project the high level classes in a common feature space
datasetLogical = 0;
for iClass = 1:numel(classesLogicals)
    datasetLogical = or(classesLogicals{iClass}, datasetLogical);
end
datasetIndexes = find(datasetLogical);

refPCA = doPca(refFeatures(datasetLogical, :), refNPcaComponents);
for iDataset = 1:length(datasetIndexes)
    PCAs(datasetIndexes(iDataset)).lvl1 = refPCA(iDataset, :);
end


% RECURSIVE CLUSTERIZATION

if nIterations > 0
    classTree.sub = {};
    for iClass = 1:numel(classesLogicals)
        classIndices = find(classesLogicals{iClass});
        subclass = treeClassification_recursive(strcat(labelsToCluster(iClass), "."), classIndices, 1);
        if ~isempty(subclass)
            classTree.sub = [classTree.sub, subclass];
        end
    end
end
