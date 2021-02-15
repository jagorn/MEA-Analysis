function wrong_trig_ind = get_wrong_trig_ind(Frames, stim_normal_delay, stim_max_difference, Latencies)
%GET_WRONG_TRIG_IND get index i of triggers that are ill received and that should not be used 
% i.e. t_i - t_(i-1)  not in  [stim_normal_delay-stim_max_difference, stim_normal_delay+stim_max_difference]

delayed_trig_ind = find(abs(diff(Frames) - stim_normal_delay)>stim_max_difference);

wrong_trig_ind = [];

for trig_ind = delayed_trig_ind(:)'
    wrong_trig_ind = union(wrong_trig_ind, -Latencies + trig_ind);
    
end

end

