classdef AnalysisResults < handle
    properties %////Comment
        Nspk
        n_Spk
        t_Spk
        t_Spk_selected %//// Just for test : remove after
        STA
    end
    methods
        function obj = AnalysisResults(Nchannel,IS,Spk_lengths,status)
            if nargin > 0
                obj.Nspk=zeros(1,Nchannel);
                R=cell(1,Nchannel);
                [R{:}] = deal(zeros(IS.NCheckerboard1,IS.NCheckerboard2,IS.Nlatency));
                obj.STA = R;
                
                if (nargin <= 3) || ~strcmp(status,'Offline')
                    U = cell(1,Nchannel);
                    [U{:}] = deal(long_array(Spk_lengths));
                    obj.n_Spk = U;
                    V = cell(1,Nchannel);
                    [V{:}] = deal(long_array(Spk_lengths));
                    obj.t_Spk = V;
                    obj.t_Spk_selected = V; %//// Just for test : remove after
                end
            end
        end
        
        function add_spks_bins (obj,nchannel,nspk) %Adds spike bins to the corresponding cell array
            function temp (obj,x,y)
                add_elements(obj.n_Spk{x},y);
            end
            arrayfun(@(x,y) temp(obj,x,y), nchannel, nspk);
        end
        
        function add_spks_times (obj,nchannel,tspk)  %Adds spike times to the corresponding cell array
            function temp (obj,x,y)
                add_elements(obj.t_Spk{x},y);
            end
            arrayfun(@(x,y) temp(obj,x,y), nchannel, tspk);
        end
        
        function add_spks_times_selected (obj,nchannel,tspk_selected)  %//// Just for test : remove after
            function temp (obj,x,y)
                add_elements(obj.t_Spk_selected{x},y);
            end
            arrayfun(@(x,y) temp(obj,x,y), nchannel, tspk_selected);
        end
    end
end