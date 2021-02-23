% experimental parameters
psth_tBin = 1/30; % s
    
% other parameters
datasetName = "20190416_gtacr";
experiments = {"20190416_gtacr"};
acceptedLabels = 4; % 5=A, 4=AB, 3=ABC

% setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)
setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)


