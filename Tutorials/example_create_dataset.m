
% Create a dataset

% the name of the dataset
dataset_name = 'my_first_dataset';

% the name of the experiments I want to add
experiments = {'TEST', 'TEST2'};
setDataset(dataset_name, experiments)

% Once the dataset has been created, you can load it:
loadDataset()

% you will see in the workspace all the processed data.
% you can also add PSTHs to the dataset:
addDatasetPSTH('euler')
addDatasetPSTH('checkerboard')
addDatasetPSTH('flicker')

% to load The psths:
loadDataset()

% we can finally plot some panels:
% you can plot all the info about a given cell like this:
plotCellCard(1)

% by default, the psth shown is the first one added (euler in our case)
% you can choose to show another psth, with this function:
changeDefaultPattern('white')
plotCellCard(1)

% You can create more than one dataset
setDataset('my_second_dataset', {'TEST'})

% to list all the datasets available:
listDatasets()

% use this function to know which dataset are you in:
getDatasetId()

% you can change, delete, or copy datasets:
changeDataset('my_first_dataset')
deleteDataset('my_second_dataset')
copyDataset('my_first_dataset', 'my_third_dataset')

