function trig_ind_l = get_trig_ind( ISg, ISs_ii, Frames,spkt_l, wrong_trig_ind, Ntrig_before)

%GET_TRIG_IND(ISg, ISs_ii, Frames,spkt_l, wrong_trig_ind, Ntrig_before) returns trig_ind_l the frame number IN THE STIMULUS FILE to which 
% a spike time corresponds. 

% spkt_l : array of times of spikes
% Frames : array of trigger times
% ISg , ISs_ii : contains the parameters of the experiment

% Ntrig_before : number of triggers occuring before Frames ( 0 by default) (separated for online experiments)

% trig_ind_l : 0 if the spike is out of the stimulus times (too early or late)


%% Compute the trigger index correponding to the spike time 

trig_ind_l=bin_spkt(Frames,spkt_l,ISs_ii.Nlatency);

trig_ind_l(ismember(trig_ind_l, wrong_trig_ind)) = 0;

if nargin > 5 
    trig_ind_l = trig_ind_l + Ntrig_before;
end

%% Because there are repetitions in the stimulus, we now compute the corresponding frame number

    function y = manage_repetitions( trig_ind, ISg, ISs_ii)
        if trig_ind <= 0
            y = trig_ind;
        else
            num_preceding_rep=floor((trig_ind-1)/(2*ISg.Nb_seq));
            trig_ind_rel = rem(trig_ind-1,2*ISg.Nb_seq)+1;
            
            is_during_rep = (trig_ind_rel > ISg.Nb_seq);
            
        
            if ISs_ii.SkipRep
                keep=(~is_during_rep)&&(trig_ind_rel>=ISs_ii.MaxLat);  % doesn't take into account spikes too close to repeted parts (MaxLat >= Nlatency, and allows more minimum delay)
                
                if keep
                    y = trig_ind - ISg.Nb_seq*(num_preceding_rep + is_during_rep);
                else
                    y = 0;
                end
            else
                keep=(trig_ind_rel>=ISs_ii.Nlatency); % doesn't take into account spikes too close to repeted parts
                
                if keep
                    y = trig_ind_rel; % because it is the first sequence that is repeated over and over
                else
                    y = 0;
                end
            end
            
            
        end
    end


switch ISg.stimulus_organization
    case 'AABACADA' % Stimulus organization in our group checkerboard algorithm
        trig_ind_l = arrayfun(@(x) manage_repetitions(x,ISg, ISs_ii),trig_ind_l);
            
    otherwise
        error([' IS.stimulus_organization is set as ' IS.stimulus_organization ' but this case has not been implemented yet']); 
        
end



end

