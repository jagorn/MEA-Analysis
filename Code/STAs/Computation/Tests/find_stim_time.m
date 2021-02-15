function n_stim = find_stim_time(t_spk,stim,IS)  %/////Check this works well!!!!

%find_stim_time(t_spk,stim,IS) returns N_STIM the number of the first bin of
%stimulus times (stored in stim.{tables}) before T_SPK

% T_SPK time of spikes
% STIM long_array containing the stimulus times
% IS contains the parameters of the experiment

% N_STIM : 0 if the spike is out of the stimulus times (too early or late)


n_stim=isKnownTime(stim,t_spk,stim);

    function y = manage_repetitions( n_stimii, IS)
        if n_stimii == 0
            y = 0;
        elseif n_stimii == -1
            y = -1;
        else
            num_preceding_rep=floor((n_stimii-1)/(2*IS.LengthRepeat));
            is_during_rep = rem(n_stimii-1,2*IS.LengthRepeat)+1;
            
            if IS.SkipRep
                y2=(is_during_rep>30);  %Nlatency; %/////is it equivalent to + MaxLat for times? Is it a good choice?  %Be careful to define y2 before modifying  is_during_rep
            end
            
            is_during_rep = (is_during_rep > IS.LengthRepeat);  %/////Check
            y = n_stimii - IS.LengthRepeat*(num_preceding_rep + is_during_rep);
            
            if IS.SkipRep
                if (~y2)||is_during_rep;
                    y=0;
                end
            end
        end
    end

n_stim = arrayfun(@(x) manage_repetitions(x,IS),n_stim);


end

