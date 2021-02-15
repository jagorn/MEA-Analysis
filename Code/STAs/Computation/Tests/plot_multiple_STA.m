%% Display multiple STAs

% For each cell, click on figure 2 will display next cell


%filename = '/media/Chris_WDElements/Results Experiments/Results Experiments - Standard/Data_Expe__2015_03_26-12_29_31_Check_f60_sqpix50_nsq15_L1ND3_200highpassfilt_spiketime_Call.data_STA_21TimeBins.mat';
%filename = '/home/christophe/Sauvegarde LPS/cours/LPS - IV/code/Multiple online analysis/Results/Expe_2015-04-16_13h-52m-37s/Standard_Spiketimes_peak_times-fromUDP.data_STA_21TimeBins.mat';
%filename = '/Volumes/Giulia_Exp/20161201/Data_Analysis/SpikeTimes.data_STA_21TimeBins.mat';
filename = '/Volumes/Giulia_Exp/20170614/SpikeTimes.data_STA_21TimeBins.mat'
Min_Nspk = 300; % minimum number of spikes for a cell to be displayed 

load(filename)
%%

stim_rate = 30;

chan_ind_l = 1:256;
chan_ind_l = chan_ind_l(Nspks>=Min_Nspk);
chan_ind_ind = 1;

while chan_ind_ind <= length(chan_ind_l)
    chan_ind = chan_ind_l(chan_ind_ind);
    
    STA = STAs{chan_ind};
    
    if ~isempty(STA)
        
        close all
        
        [~,max_ind] = max(STA(:));
        
        [x,y,t] = ind2sub(size(STA), max_ind);
        
        f_xy = figure;
        f_xy.Position(1) = 100;
        
        imagesc(STA(:,:,t));
        colorbar;
        
        f_t = figure;
        
        profile_t = squeeze(STA(x,y,:));
        plot(((1:length(profile_t))-1)/stim_rate, profile_t);
        
        title({['Channel ' int2str(chan_ind) ],[int2str(Nspks(chan_ind)) ' spikes']});
        xlabel('Time in s');
        ylim([0 1])
        
        w = waitforbuttonpress;
        if w == 0
            
            close all
            
        end
        
    else
        figure;
        
        w = waitforbuttonpress;
        if w == 0
            
            close all
        end
    end
    
    chan_ind_ind = chan_ind_ind+1;
end