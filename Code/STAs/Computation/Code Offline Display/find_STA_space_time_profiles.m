function find_STA_space_time_profiles( treated, indices ,plotdata) %////Comment 
%FIND_STA_SPACE_TIME_PROFILES Summary of this function goes here
%   Detailed explanation goes here

    function find_max(treated,x,plotdata)
        A=treated.STA{x}/treated.Nspk(x)-1/2;
        [~, position] = max(abs(A(:))); 
        [i,j,k] = ind2sub(size(A),position);
        plotdata.STAtime{x} = squeeze(A(i,j,:));
        plotdata.STAspace{x} = A(:,:,k);
    end

       
arrayfun(@(x) find_max(treated,x,plotdata),indices);

end

