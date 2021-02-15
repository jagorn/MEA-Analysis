function n_stim = find_stim_time2(t_spk,stim,IS)  %for Jared, who uses a different style of repetitions

%find_stim_time(t_spk,stim,IS) returns N_STIM the number of the first bin of
%stimulus times (stored in stim.{tables}) before T_SPK

% T_SPK time of spikes
% STIM long_array containing the stimulus times
% IS contains the parameters of the experiment

% N_STIM : 0 if the spike is ou t of the stimulus times (too early or late)


n_stim=isKnownTime(stim,t_spk,stim);

    function y = manage_repetitions( n_stimii, IS)
        if n_stimii == 0
            y = 0;
        elseif n_stimii == -1
            y = -1;
        else
            num_preceding_rep=floor((n_stimii-1)/(2*IS.LengthRepeat));
            is_during_rep = rem(n_stimii-1,IS.length_constant_part+IS.length_variable_part)+1;
            
            
            is_during_rep = (is_during_rep < IS.length_constant_part);  
          
            
            if IS.SkipRep
                if is_during_rep;
                    y=0;
                end
            end
        end
    end

n_stim = arrayfun(@(x) manage_repetitions(x,IS),n_stim);


end

