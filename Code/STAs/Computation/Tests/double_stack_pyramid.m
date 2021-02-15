classdef double_stack_pyramid < handle
    %DOUBLE_STACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nlevels
        lengths
        times
        cells
    end
    
    methods
        function obj = double_stack_pyramid (N_levels,lengths)
            obj.lengths = lengths;
            obj.Nlevels=N_levels;
            for ii = 1:N_levels
                obj.times{ii} = long_array(lengths);
                obj.cells{ii} = long_array(lengths);
            end
        end
               
        function add_elements (obj, nlevel, ncell, ntime)
            add_elements(obj.times{nlevel},ntime);
            add_elements(obj.cells{nlevel},ncell);
        end
             
    end
    
end

