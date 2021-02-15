function Nframes = get_min_Nframes_from_Ntrig( IS, Ntrig )
%GET_MIN_NFRAMES_FROM_NTRIG computes Nframes, an upper bound of the number of frames involved
% in an experiment with  Ntrig triggers

switch IS.stimulus_organization
    case 'AABACADA' % Stimulus organization in our group checkerboard algorithm
        
            Nframes = mod(Ntrig, IS.Nb_seq) + IS.Nb_seq*ceil(Ntrig/(2*IS.Nb_seq));
        
    otherwise
        error([' IS.stimulus_organization is set as ' IS.stimulus_organization ' but this case has not been implemented yet']);
        
end

end

