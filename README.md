# MEA_Analysis

A comprehensive set of scripts for handling and analyzing Multi Electrode Array recordings of the retina.

With this package you can process raw files and the spike-sorting results from spyking circus.
You can analyze the responses to visual stimuli to compute receptive fields, psths, type your cells, and generate plots.

# Installation

## Installation and Configuration
1. Download the MEA Analysis package [here](https://github.com/jagorn/MEA-Analysis).
2. Download the Checkerboard file [here](https://drive.google.com/file/d/1pBHTdfZaLZumMlbEKDsI1TqGR8F5ZnIC/view?usp=sharing), and save it into the following project directory:
*/my_project_path/MEA_Analysis/Stimuli/checkerboard/binary*
3. Add the */my_project_path/MEA_Analysis/Code* folder to the MATLAB Path. 

## Data Configuration
Your *Data Path* is the folder where you store your data.
The MEA_Analysis package looks for the data in this folder, and saves its variables here. 

In order to configure your *Data Path* you must fill the configuration file:
*/my_project_path/MEA_Analysis/data_path_configuration*.

Here you can list all the possible data paths, each represented with a name and a path.

By default, the package will look for your data in the first data path listed in the configuration file.
From the MATLAB terminal, you can use the functions of the MEA_ANALYSIS/DATA Manager Package to change or list your data paths.
In particular:
  * use dataPath() to get the current data path
  * use listDataPaths() to get the list of available data paths.
  * use changeDataPath(datapath_name) to change the data path.
  
## Stimuli 
The stimuli folder (*/my_project_path/MEA_Analysis/Stimuli*) contains data about all the visual stimuli recognized by this package.
For each stimulus type, you have a subfolder, named after the stimulus, where the time stamps of the repeated patterns of the stimulus are saved.
This information is used by the package to analyze the retinal responses and generate PSTHs and Receptive Fields.


# Analyze Single Experiments

## Initialize the experiment
The first thing to do when you want to analyze a new experiment is to create the experiment folder.
You can do that by using the command:
*initializeExperiment(exp_id)*, where exp_id is the name of the experiment of your choice.

By doing so, you initialize the experiment folder inside your data path.
As you will see, inside this folder (*my_data_path/exp_id*) you now have a few folders and files.

In order to analyze the experiment, we must tell the program which stimuli we played during the recordings, and at which time.
To do so, you must fill the *stims.txt* file inside the experiment folder.
Here you can specify all the stimuli you played and under which conditions (for example: during the application of some pharmacology).

If you want the program to be able to recognize these stimuli and compute repetitions and psths, make sure to use the same stimulus names as in the STIMULI folder (for example: *euler*, *checkerboard*, *flicker*).

## Initialize the sections
Once the *stim.txt* file has been compiled, we can divide our experiment in sections (each section is a portion of the recordings for which a particular stimulus was played).

In order to do so, use the function:
*initializeSections(exp_id)*

You will notice now that inside your experiment folder, a new folder was created for each experiment section.
Inside each section you will also find a configuration file *config.txt", with information about the stimulus played
(for example: the mea rate, the frame rate, the stimulus version).
Make sure all of these parameters are filled correctly.

## Process the experiment
We are finally ready to process our experiment!
Use the function: 
*extractExperiment(exp_id, mea_rate)*

This function will:
1. Extract the triggers from the .raw experiment file
2. Import the spike-sorting results from the spyking-circus output files.
3. Compute all the repetitions of the repeated parts of the stimuli.

* The .raw file by default is expected to be in *my_data_path/exp_id/sorted*. 
You can use optional parameters to provide a different path/name for this file.

* The folder with the spike-sorting results is expected to be in *my_data_path/exp_id/sorted*. 
You can use optional parameters to provide a different path/name for the folder.


Among the other things, this function will save a *repetitions.mat* file in each of your section folders, with all the time stamps of the repeated portions of the stimuli.

You halso have a *sectionsTable.mat* file that sums up all the information about the stimuli played.

## Adding a new stimulus
Repetitions can only be computed on the stimuli known by the program.
If you want to compute repetitions for a stimulus that is not recognized by the program, you must first add this stimulus to the package

In order to add a new stimulus you must:
1. create a subfolder named after the stimulus in the stimuli folder (*/my_project_path/MEA_Analysis/Stimuli*), for example *white_discs*
2. For each version of this stimulus, you must create inside the folder a mat file called after the stimulus version (for example *white_discs_simple.mat*)
3. Inside this matlab folder, you must save the repetitions map for the repeated portions of the stimulus, following this sintax:

* repetitions_map: a cell array describing the structure of the stimulus.
*    repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
*    repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
*    repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
*    repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

Check out the examples in the *Code/Repetitions/Maps* Folder to see how to create repetition maps for new stimuli.

## Plots
You can plot raster plots and psths for repeated portions of the stimuli.
To do so, use the function: *plotSectionPSTH(exp_id, section_id)*, where section_id is the name of the section (the same as its folder name).
You can specify which cells you want to plot, or which repeated patterns in the optional parameters.


## Compute The STAs
If in your experiment you played a checkerboard stimulus, you can use it to generate spike-triggered averages and receptive fields for your cells.

Use the function *computeSTAs(exp_id)* to compute the STAs of your cells.
This function will generate the 3d STAs, and the defactorized temporal and spatial components.
This variables are then saved in the *Sta.mat* file in the experiment folder.

# Analyze Datasets

## Create a Dataset
If you need more complex analysis or further processing of your data, you can create datasets.
Datasets pool together data (PSTHs, STAs) from one or more experiments.
You can then visualize and compare responses of cells from different experiments.
You can also cluster your dataset, and identify the functional cell types.

To create a new dataset:
1. Initialize and extract the data for all the experiments you want to include to the dataset as described in the sections above.
2. Compute the STAs for all the experiments you want to include as described above
3. Use the function *setDataset(dataset_name, experiments)* to create the dataset.

You have now created a new dataset, which includes all the receptive fields, spike times and temporal stas of all your cells.
In order to load your dataset into the workspace you can use the function *loadDataset()*

In your dataset you will find a table called CellsTable, which lists all the cells composing the dataset.

# Modify and Change a Dataset
You can generate as many datasets as you want, and they all will be saved in memory.
For all operations on datasets, you can use the functions in the *MEA_ANALYSIS/DATASET Manager Package.*

In particular you can:
* list all of your datasets: *listDatasets()*
* change the active dataset: *changeDataset(dataset_name)*
* get the identifier of the active dataset: *getDatasetId()*
* delete a dataset: *deleteDataset(dataset_name)*
* copy a dataset: *copyDataset(dataset_name)*

# Add PSTHs to a Dataset
You can add as many PSTHs as you want to your dataset.
Once you have created the dataset, use the function *addDatasetPSTH(stim_id)* to add the psth to the stimulus *stim_id* to the Dataset.

The program will look in each experiment of the dataset, find the sections containing the chosen stimulus, compute the psths, and add them to the dataset.

Each stimulus might have several repeated patterns (for example, for the flicker stimulus you might want to compute pshts respect to the white flashes or to the black flashes). You can use the optional parameters of the function *addDatasetPSTH* to specify which repeated patterns you want to add to the dataset.

If you load your dataset, you will now see that inside the workspace you have a structure *psths*, where all the psths computed have been saved.

You can add as many PSTHs you want to your dataset. You can check which PSTHs have been included in your dataset using the function *listPSTHs()*


## Plots
You can use the functions from the package *Code/Dataset Processor/Plots* to plot the responses of your cells.
For example:
* *plotISI(i_cell)* to plot the inster-spike interval distribution of cell *i_cell*
* *plotTSTA(i_cell)* and *plotSSTA(i_cell)* to plot the temporal and spatial components of the stas
* *plotPSTH(i_cell, pattern_name)* to plot the PSTH of cell *i_cell* to the repeated pattern *pattern_name*.

You can also use the function *plotCellCard(i_cell)* to plot a panel with all the data above for a given cell *i_cell*.

By default, cell cards will show the PSTHs to the first repeated pattern added to the dataset (this is the default psth pattern).
To change the default psth pattern, use: *changeDefaultPattern(psth_pattern)*

## Cell Typing
To find functional cell types in your dataset, use the *classifyDataset()* function.
This function will use some features of your cells (temporal stas, psths, receptive field size) to cluster together cells functionally similar and identify plausible groups of cell types.

You can personalize the clustering process by changing the parameters inside the funtcion.

Once you run this script, in your dataset you will find a table called ClassesTable, which summarizes the results of the clustering.

To visualize your clusters of cells, you can use several functions:
* *plotLeafFeatures()* to visualize a panel with all the clusters together, plotting average STA and PSTH for each of them.
* *plotLeafCards()* to visualize a card for each cluster, including mean temporal STA, mean PSTH, and Receptive fields tiling. 
