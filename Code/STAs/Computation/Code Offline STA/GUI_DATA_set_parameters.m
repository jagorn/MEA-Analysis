classdef GUI_DATA_set_parameters < handle
    %GUI_DATA_SET_PARAMETERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        NCheckerboard1
        NCheckerboard2
        
        Nlatency
        
        Channels
        
        StimFilePath
        StimFileFormat
        
        triggers_file
        spikes_file
        
        SkipRep
        MaxLat
        
        
        
        stim_freq
        MEA_recording_freq
    end
    
    methods
        
         % Make a copy of a handle object.
        function new = make_copy(obj)
            % Instantiate new object of the same class.
            new = feval(class(obj));
 
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end
    end
    
end

