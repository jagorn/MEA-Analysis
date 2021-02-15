function f = plot_STA_time( STA )
%PLOT_STA_TIME 


        [~,max_ind] = max(STA(:));
        
        [x,y,~] = ind2sub(size(STA), max_ind);
        
        profile_t = squeeze(STA(x,y,:));
        
        stim_rate = 60;
        
        f = figure;
        plot(((1:length(profile_t))-1)/stim_rate, profile_t);
        
        %title({['Channel ' int2str(chan_ind) ],[int2str(Nspks(chan_ind)) ' spikes'],['stim_rate = ' stim_rate 'was supposed']});
        title({['stim_rate = ' int2str(stim_rate) 'was supposed']});
        xlabel('Time in s');
        %ylim([0 1])

end

