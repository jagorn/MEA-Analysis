% --------- RGC ------------%

% Clustering parameters RGC
c_params_RGC.min_size = 7;
c_params_RGC.split_size = 10;

c_params_RGC.min_psth_SNR = .6;
c_params_RGC.min_sta_SNR = .9;

c_params_RGC.split_psth_SNR = .825;
c_params_RGC.split_sta_SNR = .95;  
% 
% rgc_dataset_label = "RGC";
% labels_neurons = containers.Map;
% changeDataset(rgc_dataset_label);
% load(getDatasetMat(), "cellsTable");
% labels_neurons(char(rgc_dataset_label)) = logical(1:numel(cellsTable));
% 
% treeClassification(c_params_RGC, labels_neurons);


% --------- CNN ------------%

% Clustering parameters CNN
c_params_CNN.min_size = 7;
c_params_CNN.split_size = 10;

c_params_CNN.min_psth_SNR = .5;
c_params_CNN.min_sta_SNR = .9;

c_params_CNN.split_psth_SNR = .75;
c_params_CNN.split_sta_SNR = .95;

cnn_dataset_label = "CNN";
changeDataset(cnn_dataset_label);
load(getDatasetMat(), "cellsTable");
labels_models = containers.Map;
labels_models(char(cnn_dataset_label)) = logical(1:numel(cellsTable));

treeClassification(c_params_CNN, labels_models);