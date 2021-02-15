function trig_ind_l = bin_spkt( Frames, spkt_l, Nlatency)
%BIN_SPKT( Frames, spkt_l, Nlatency)

% bin the spikes, 0 indicates that the spike cannot be used for STA analysis

if isempty( spkt_l )
    trig_ind_l = spkt_l;
else
    
    [~,trig_ind_l] = histc(spkt_l, Frames);
    
    trig_ind_l(trig_ind_l == length(Frames)) =0; % spikes after the last trigger are not considered
    
    trig_ind_l(trig_ind_l < Nlatency) = 0; % spikes which arrived too early for STA computation are not considered
    
   
end


end

