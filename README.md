# MEA_Analysis

A comprehensive set of scripts for handling and analyzing Multi Electrode Array recordings of the retina.

# Installation

## Installation and Configuration
1. Download the MEA Analysis package [here](https://github.com/jagorn/MEA-Analysis).
2. Download the Checkerboard file [here](https://drive.google.com/file/d/1pBHTdfZaLZumMlbEKDsI1TqGR8F5ZnIC/view?usp=sharing), and save it into the following project directory:
*/my_project_path/MEA_Analysis/Stimuli/checkerboard/binary*
3. Add the */my_path/MEA_Analysis/Code* folder to the MATLAB Path. 

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

## Plots



## Compute The STAs

# Create a Dataset

# Plots

# Cell Typing


