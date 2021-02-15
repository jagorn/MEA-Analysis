classdef expendable_array < handle
    %LONG_ARRAY Summary of this class goes here
    % /////  Detailed explanation goes here
    
    properties
        lengths
        tables
        max_times % if t is superior to max_times(i), then t is not in tables{j} for j<=i for sure. In practice it is the minimum defined time of tables{i+1}
        Nlatency
        Latencies
        delayedtimes % list of n where the delay between t_(n+1) and t_n is anormally long (corresponding spikes are not considered for analysis)
        max_delayedtimes %maximum of this list (used a lot)
        max_delay %maximum delay authorized for a trigger to be taken into account
        normal_delay %normal delay between triggers
    end
    
    methods
        function obj = expendable_array(l,IS,normal_delay,max_delay)
            obj.lengths=l;
            obj.tables=NaN(l,1);
            obj.max_times=NaN;
            obj.delayedtimes = long_array(30);
            obj.max_delayedtimes = 0;
            obj.max_delay = max_delay;
            obj.normal_delay = normal_delay;
            
            if nargin > 1
                obj.Nlatency = IS.Nlatency;
                obj.Latencies = IS.Latencies;
            end
            
        end
        
        function include_element (obj,n,x)
            
            if max(n)>length(obj.tables)
                n_array=floor((max(n)-1)/obj.lengths)+1;
                n_add = n_array - length(obj.tables)/obj.lengths;
                obj.tables = [obj.tables ; NaN(n_add*obj.lengths,1)];
            end
            
            obj.tables(n)=x;
            
            n_inf  = n(n<length(obj.tables));
            d1 = abs(obj.tables(n_inf+1) - obj.tables(n_inf) - obj.normal_delay)>obj.max_delay;
            include_delayedtime(obj,n_inf(d1 == 1));
            
            n_sup  = n(n>1);
            d2 = abs(obj.tables(n_sup) - obj.tables(n_sup-1) - obj.normal_delay)>obj.max_delay;
            include_delayedtime(obj,n_sup(d2 == 1)-1);
        end
        
        
        function include_delayedtime(obj, n) %also include elements Nlatency after the last delayed time
            if ~isempty(n)
                tab = repmat(obj.latencies,[length(n) 1]) + repmat(n,[1 obj.Nlatency]);
                tab = unique(tab(:));
                add_elements(obj.delayedtimes, tab);
                
                if max(n)+obj.Nlatency-1>obj.max_delayedtimes
                    obj.max_delayedtimes = max(n)+obj.Nlatency-1;
                end
            end
        end
        
        function n_stim = isKnownTime (obj,t,stim)  %////Arrange to take advantage of max_times  %////Comment 0 if not an adapted time, -1 if not yet known
            % n_stim : bins such that obj.tables(n_stim) and
            % obj.tables(n_stim+1) are not NaN and obj.tables(n_stim) <= t  < obj.tables(n_stim+1)
            
            if isempty(t)
                n_stim = t;
            else
                
                n_stim = arrayfun(@(x) find( x >= [-Inf; obj.tables],1,'last') ,t);
                
                n_stim = n_stim - 1;
                
                noKeep = isnan(obj.tables);
                
                tooEarly = arrayfun(@(x) ~any(stim.tables(1:length(obj.Latencies))> x),t); % 0 if too early, 1 else
                
                %fprintf('length of n_stim : %d \n', size(n_stim));
                %fprintf('length of n_stim == length : %d \n', size((n_stim==length(obj.tables))));
                %fprintf('length of n_stim & : %d \n', size(( noKeep(n_stim+1))));
                
                n_stim( (n_stim==length(obj.tables)) | (0<n_stim & n_stim<length(obj.tables) & noKeep(n_stim+1)))=-1;
                
                n_stim = tooEarly.*n_stim;
                
                select = n_stim > 0; %exclude delayed times
                not_delayed = (n_stim(select)>obj.max_delayedtimes)|~ismember(n_stim(select),obj.delayedtimes.table);
                n_stim(select) = n_stim(select).*not_delayed;
            end
        end
        
    end
end

