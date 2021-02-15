
function treat_time_array_offline(treated,Frames,spk_times,spk_cells,IS,checkerboard, wrong_trig_ind)
%STIM_TIME_FROM_ARRAY

% BEWARE : spk_cells can be of length 1 if all the spikes are from the same cell

trig_ind = get_trig_ind(IS, IS, Frames,spk_times, wrong_trig_ind); % normal to hawe twice IS entered here

computableTimes = (trig_ind>0);

if length(spk_cells)>1
    STA_partial(treated,spk_cells(computableTimes),trig_ind(computableTimes),IS,checkerboard);
else
    STA_partial(treated,spk_cells,trig_ind(computableTimes),IS,checkerboard);
end

end

