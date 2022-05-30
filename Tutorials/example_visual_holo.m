

% DATA PATH

% First of all, you need to configure your data paths.
% Data paths are were all you data is stored.
% You can configure your data paths editing the file
% data_path_configuration.txt

% to visualize all your data paths:
listDataPaths;

% to change your current data path:
changeDataPath('laptop')



% EXPERIMENTS

% now you are ready to create your first experiment.
initializeExperiment('my_test');

% this command creates a folder in your data path for the new experiment.
% Now you need to fill the file stims.txt inside the folder.
% In this file you specify which stimuli were played during the
% experiment and in which order.
% You also specify the conditions (pharmacology, filters, objective) under
% which each stimulus was played

% then we initialize the sections of the experiment:
initializeSections('my_test')
% Every section corresponds to a stimulus that was played in the
% experiment.
% Every section has its own subfolder in the experiment folder, with a 
% config file that needs to be edited. 
% Default config for euler and checkerboard are fine. 
% For discdelay make sure you select the correct "version" of the stimulus
% (the latest version is spots_fast_white_disc_delay). 


% now we are ready to extract data from our experiment.
% typically you want to put all the raw and sorted data in the "sorted"
% folder. Then the program will parse them and save the processed results
% in the "processed" folder;

% the first command you need is extractExperiment.
extractExperiment('my_test', 20000, 'Raw_Name', 'full',  'Sorting_Name', 'full');

% It has a lot of optional parameters (you can check out the documentation in the function file).
% you can choose to extract only triggers or also repetitions, spike times
% multi units etc.

% If the raw and sorted files are not in the "sorted folder" you can
% specify their current location with optional parameters.

% check out all the optional parameters in the function documentation.

% It is recommended to first extract only the triggers. 
% Then sort the raw file (with consequent filtering), and then extract spike trains.

% Now you have everything you need (spike trains, repetitions) for visual stimuli;

% You can look at a summary of your sections using:
printSectionsTable('my_test'); 

% To compute STAs and receptive fields:
computeSTAs('my_test')
% ...and all RFs will be computed and saved in the experiment folder.
% If you have more than one checkerboard section, you can use the optional
% parameters to choose which one to use to compute the RFs.

% to visualize the STA of a cell:  (cell #17 for example...)
plotExpSTA("my_test", 17)

% You can now visualize your data plotting raster-plots or PSTHs.
euler_section = 2;
plotSectionRaster("my_test", euler_section, 'euler')
% you need to specify the number of the visual section you want to plot
% (as reported in the section table) and the name of the stimulus.

plotSectionPsth("my_test", euler_section)
% check the function documentation for more info on optional parameters

% to compute the PSTHs of your responses:
repetitions = getRepetitions("my_test", euler_section);
spike_times = getSpikeTimes("my_test");
mea_rate = getMeaRate("my_test");

psth_euler = sectionPSTHs(spike_times, repetitions, mea_rate, 'Time_Spacing' , 0.5);
% this variable is a structure with all the data you need about concerning the RGC responses
% Time spacing is the time interval (s) you want to consider before and after stimulus offset.

% plot:
figure();
plot(psth_euler.responses{1}');
waitforbuttonpress();
close();


% HOMOGRAPHIES

% When you play any kind of stimulus, you need to determine its location,
% i.e. its reference frame, so that you can relate the position of
% the RGCs you record from with the position of the stimulus.

% To do this we use homographies, which are matrices representing
% projective transformations of point and planes in a 2D space.

% Some homographies are FIXED, meaning they don't depend on the current
% status of the rig, and have always same values.
% Examples: the transformation between Camera and DMD is fixed, because
% they always move together.

% Other transformations depend on the current configuration of the rig.
% Examples: Camera to MEA depends on the current location of the MEA.

% To initialize you table of homographies: (just need to do this once and it will be set forever)
initializeHomographies();
% This will load and store all the fixed homographies.

% you can visualize all the homographies saved using:
listHomographies();

% You can see that here we also have homographies for CAMERA to MEA, for
% both x10 and x40 objective. These are computed assuming that the CAMERA
% is perfectly centered on the MEA.

% if during an experiment you move the MEA and/or camera with respect to
% each others, you need to compute the corresponding homography.
% This homography can be computed based on a picture of the MEA you took
% from the stimulus location.
% In order to do so, you can do:
setH_Photo2MEA('my_test', 'holo_pic', '.jpg');
% Where 'holo_pic' is the name of the picture (must be of size 672*512 pxl)
% You have to click on 5 different electrodes, and input in the console
% their corresponding coordinates in terms of electrode raw and column
% (from 1 to 16).

% now if you check the list of homographies, you will see the new
% homographies are stored as well.
listHomographies();

% This step is necessary when you use holographic stimulation on the side
% of the MEA, or when you display visual stimuli in the surround.


% HOLOGRAPHY

% Let's now move to holography
extractHolography('my_test', 'Raw_Name', 'full');
% this is really similar to extractExperiment, with similar optional
% parameters. you use it to extract DH triggers and repetitions;

% Now you will be asked to go to the holography folder and fill the
% configuration file.
% you have to specify in the stim_holo.txt which DH_Frames files were
% used, and in which order.
% Copy all of the DH_Frames files in the Holography folder inside your
% experiment.

% Now run the command again to extract the DH repetitions and spot positions
extractHolography('my_test', 'Raw_Name', 'full');
% you will also asked to add an image for this holographic section.
% this should be the picture taken with the camera from the same position
% where you performed the stimulation (same used to compute the homography).

% Now to have a recap on the DH info you can use:
printHolographyTable('my_test')



% VISUAL AND HOLOGRAPHY

% To test whether DH and DMD triggers are correctly synchronized, use:
testVisualHoloSynchronization('my_test');
% This will plot a dot for each DMD trigger, colored according to the .vec file: 
% green dots are triggers that should be aligned to open DH shutter.
% In blue, you have the time intervals at which the DH shutter is open
% according to the DH triggers.
% If synchronization is correct, green dots and blue lines should align.

% Put visual and holography together:
extractVisualHoloRepetitions('my_test', 3, 1)
% here we want to macht the visual stimulation with the corresponding holographic stimulation.
% the second parameter is the index of the visual sitmulation (number on the left).
% You can check it up using the command printSectionsTable.
% The third paramter is the index of the DH stimulation. 
% You can also check it up with printHoloTable.

% After you run the command you will see two new sections appearing in the HoloTable:
% one for repetitions of pure DH and one for repetitions of DH + visual
printHolographyTable('my_test')



% HOLOGRAPHY PSTHs
% To compute the PSTHs for each of the holographic pattern in your table:
computeHolographyPSTHs('my_test');
% As for PSTHs to visual stimuli, you can check the documentation of the function
% for further functionalities and optional paremeters.

% To get the PSTH variable:
my_holo_psths = getHolographyPSTHs('my_test');

% To plot the PSTHs by pattern:
dh_section = 3;  % Chose the section according to the HoloTable IDs
holo_pattern = 1;  % this is the holographic pattern you want to visualize
rgc_idx = 1:20;  % to visualize the first 20 RGCs
plotHoloPSTHsByPattern('my_test', dh_section, holo_pattern, rgc_idx);
% or to visualize it as a raster:
plotHoloPSTHsByPattern('my_test', dh_section, holo_pattern, rgc_idx, 'Mode', 'raster');


% To visualize the PSTHs by RGC:
rgc_id = 1;
plotHoloPSTHsByCell('my_test', dh_section, rgc_id);



% SURROUND ANALYSIS
% You have now all the data you need to run the surround analysis
% check out the script and fill out the parameters.
visualize_surround



% DATASETS  (NO NEEDED FOR VISUAL-HOLO ANALYSIS)

% datasets are matlab file where you store data from one or more experiments for analysis
% all datasets are stored in the Dataset folder inside the project.

% you create a dataset with setDataset (name of dataset, list of experiments)
setDataset('my_test', {'my_test'})

% load Dataset in the workspace:
loadDataset();

% for more information about datasets, check the tutorial
% "example_create_dataset.m"

% for more info check Dataset Manager in the code folder
addAllDatasetPSTHs() % to add all psths

% to plot cell cards: 
plotCellCard(17) % with the parameter being the cell number

% to change the psth plotted use:
changeDefaultPSTH('euler', 'simple');
plotCellCard(17);


