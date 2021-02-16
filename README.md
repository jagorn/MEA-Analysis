# MEA_Analysis

A comprehensive set of scripts for handling and analyzing Multi Electrode Array recordings of the retina.


# Installation

## Installation and Configuration
1. Download the MEA Analysis package [here] (https://github.com/jagorn/MEA-Analysis).
2. Download the Checkerboard file [here] (https://drive.google.com/file/d/1pBHTdfZaLZumMlbEKDsI1TqGR8F5ZnIC/view?usp=sharing), and save it into the following project directory:
_*/my_project_path/MEA_Analysis/Stimuli/checkerboard/binary*_
3. Add the _*/my_path/MEA_Analysis/Code*_ folder to the MATLAB Path. 

## Data Configuration
Your _*Data Path*_ is the folder where you store your data.
The MEA_Analysis package looks for the data in this folder, and saves its variables here. 

In order to configure your -*Data Path*- you must fill the configuration file:
_*/my_project_path/MEA_Analysis/data_path_configuration*_
Here you can list all the possible data paths, each represented with a name and a path.

By default, the package will look for your data in the first data path listed in the configuration file.
From the MATLAB terminal, you can use the functions of the MEA_ANALYSIS/DATA Manager Package to change or list your data paths.
In particular:
  * use dataPath() to get the current data path
  * use listDataPaths() to get the list of available data paths.
  * use changeDataPath(datapath_name) to change the data path.
  
## Stimuli 
The stimuli folder (_*/my_project_path/MEA_Analysis/Stimuli*_) contains data about all the visual stimuli recognized by this package.
For each stimulus type, you have a subfolder, named after the stimulus, where the repetition times of the repeated patterns of the stimulus are saved.
This information is used by the package to analyze the retinal responses and generate PSTHs and Receptive Fields.


# Analyze Single Experiments
The first thing to do when you want to analyze a new experiment is to create the experiment folder.
You can do that by using the command:
-*initializeExperiment(exp_id)*-, where exp_id is the name of the experiment of your choice.

By doing so, you initialized the experiment folder inside your data path.
As you will see, inside this folder (-*my_data_path/exp_id*-) you now have a few folders and files.

