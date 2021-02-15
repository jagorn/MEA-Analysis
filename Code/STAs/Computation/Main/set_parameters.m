
% use of GUI to set parameters
IsUseGUI_set_parameters = 0;

% Default parameters are used if GUI isn't
IsUseDefaultParameters=~IsUseGUI_set_parameters;

% IS contains the parameters of the experiment that have to be passed to functions:
IS=online_STA_parameters();

%%  Parameters %%

%%% Stimulus triggers %%%
% must contain peak_times or Frames, list of trigger times
triggers_file = sta_params('triggers_file');

%%% Stimulus checkerboard file (must be a .mat file. Use convert_stim_from_binary_file to convert a binary file into .mat) %%%
% must contain _nsqXXXX_ with XXXX the number of quarres per screen side during display
StimFileFormat =  'binary'; %'.mat'; %
IS.StimFilePath = sta_params('binary_file');

%%% Spike time files %%%
% can be a .data containing SpikeTimes, cell of spike times for each cell, OR 1 .mat data for each cell containing SpikeTime, list of the spike times
spikes_file = sta_params('spikes_file');
    
%%% Channels to analyse %%%
Channels = sta_params('channels');

IS.Nlatency = str2double(sta_params('n_time_bins'));  % by default 21 different time bins (-20 : 0)   
IS.NCheckerboard1 = str2double(sta_params('side1_check')); %number of squarres per side in the checkerboard. 20 by default.
IS.NCheckerboard2 = str2double(sta_params('side2_check'));%IS.NCheckerboard1; % By default it is the same value in our team's display program
IS.SkipRep = 1; % skips the spikes during the part of the stimulus which is repeated many times
IS.MaxLat = IS.Nlatency + 10; % Only used if SkipRep == 1. Skips the spikes during the part of the stimulus which is repeated many times, and those accuring MaxLat bins after
stim_freq = str2double(sta_params('stim_freq')); %Stimulus frequency in Hz (typically 60, 50 or 30)


%% Parameters that should not change %%

IS.Nb_seq = str2double(sta_params('block_size')); %Length of stimulus repetitions (when there are repetitions) : every sequences of length 600, a sequence of lenght 600 (always the same) is displayed.
MEA_recording_freq = str2double(sta_params('mea_rate')); % MEA recording frequency in Hz (typically 20000)

%Stim delay parameters (if the difference between two triggers is more than stim_max_diffence different of 1/stim_frequency, the corresponding time
%bin is not taken into account for analysis (spikes in this bin and the Nlatency after are removed)
stim_max_difference = 5; % In 1/20000 seconds. (Typically 5)

IS.stimulus_organization = upper(sta_params('block_pattern')); % ('AABACADA') specifies how the stimulus frames are read : a sequence (A) is repeated all over the experiment


%% Call the General User Interface to set the parameters
if IsUseGUI_set_parameters
    [IS,stim_freq,MEA_recording_freq,Channels, triggers_file, spikes_file,StimFileFormat]=...
        GUI_set_parameters(IS,stim_freq,MEA_recording_freq,Channels, triggers_file, spikes_file, StimFileFormat);  
end


%% Display options %%

IS.dispDataToSend = 0; %only for  test
IS.dispStepContent = 0; 



