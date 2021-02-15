 %% Parameters

NCheckerboard = 15; % number of sequares per screen side;

BitFilePath = '/media/SAMSUNG/Chris_save/sauvegardes 2T/cours/LPS - IV/code/Christophe_STA/Christophe_STA/binarysource1000Mbits'; % Path to the '.bit' file containing the stimulus

Nframes_max = 10*60*60; % Maximum length of the checkerboard file ( in Frame numbers )  (convenient to write as Nminute*Nsec_per_minute*Nframes_per_sec)
% Can be set to Inf if no restrictions are set, but the result file can be very large. If the file is too small, it is detected at the beginning of the Offline STA program.
%%
[checkerboard, Nframes, path_proposal] = stim_from_binary_file(BitFilePath, NCheckerboard, NCheckerboard, Nframes_max); % conversion

save(path_proposal, 'checkerboard', 'Nframes','-v7.3'); % saves at with path and name recognized by Offline STA program
