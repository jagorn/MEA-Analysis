classdef data_for_plot < handle
    %DATA_FOR_PLOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Channels
        STAspace
        STAtime    
        lastsavefile
    end
    
    methods
        function obj = data_for_plot (treated,IS)
            obj.Channels = 1:length(treated.STA);  %Beware if it changes
            
            for ii = obj.Channels
                obj.STAtime{ii} = zeros(1,IS.Nlatency+1);
                obj.STAspace{ii} = zeros(IS.NCheckerboard1, IS.NCheckerboard2);
            end  
            
            find_STA_space_time_profiles(treated, obj.Channels ,obj);
            
        end
        
    end
    
end

