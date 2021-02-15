classdef long_array < handle 
    %LONG_ARRAY : array (used as a stack) of automatically modified size.
    % When adding elements, if the array y.table is not long enough,
    % y.lengths zeros are added after y.table. This keeps from
    % reallocating space for each new element, thus saving time if a lot of
    % elements are allocated during a task.
    
    properties
        table %array of elements 
        lengths %length to add to y.table if it is not long enough
        index % index of the last element added. 0 if empty.
    end
    
    methods
        function y = long_array(lengths)
            y.lengths = lengths;
            y.table = zeros(lengths,1);
            y.index = 0;
        end
        
        function add_elements(y,elements)
            %ADD_ELEMENTS(Y,ELEMENTS) adds the array ELEMENTS at the end of
            %Y.TABLE, and make Y.TABLE longer if needed
            
            if (y.index + length(elements)) > length(y.table)
                y.table = [y.table; zeros(y.lengths,1)];
            end
            y.table(y.index+1: y.index + length(elements) ) = elements;
            y.index = y.index + length(elements);
        end
        
        function place_elements(y,elements,indices)
            %adds ELEMENTS to Y.TABLE at indices INDICES
            
            % BEWARE : after the use of this function, Y.INCEX doesn't
            % signify anything anymore
            if max(indices)>length(y.table)
                y.table = [y.table; zeros(y.lengths*ceil(max(indices)-length(y.table)),1)];
            end
            
            y.table(indices) = elements;
            
        end
    end
            
    
    
end

