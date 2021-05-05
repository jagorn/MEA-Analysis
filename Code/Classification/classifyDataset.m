function classifyDataset()
% Performs the classification of the cells in the current dataset.
% All the cells get divided in clusters representing types.


% RELEVANT PARAMETERS:
% clusters_params.features_psths:               a cell array of psths names to use as features
% clusters_params.first_iteration_only_STAs:    if true, the first iteration of the clustering is based only on the sta
load(getDatasetMat, 'cellsTable', 'psths', 'temporalSTAs', 'RFs');

% clustering parameters
clusters_params.features_psth_patterns = {"euler"};
clusters_params.features_psth_labels = {"simple"};
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
    

% features parameters
features_psths = [];
for i_psth = 1:numel(clusters_params.features_psth_patterns)
    features_psths = [features_psths psths.(clusters_params.features_psth_patterns{i_psth}).(clusters_params.features_psth_labels{i_psth}).psths];
end

features_matrix = generateStandardFeatureVec(features_psths, temporalSTAs, getRFArea(RFs));


[clustersTable, classTree, PCAs, clusters_params] = treeClassification(cellsTable, features_matrix, features_psths, temporalSTAs, 'Parameters', clusters_params);

save(getDatasetMat, 'features_matrix', 'features_psths', '-append');
save(getDatasetMat, 'clusters_params', 'clustersTable', 'PCAs', 'classTree', '-append');
buildClassesTable();