function STA_partial(treated,chan_ind_l,trig_ind_l,IS,checkerboard)
%STA_partial : sum all the spike triggered stimulus in treated.STA{chan_ind}

% ///// Could be made faster by summing directly

    function one_time_STA (trig_ind,chan_ind,treated,IS,checkerboard)
        %fprintf('cell : %d \n',ii)
        %fprintf('n_time : %d \n',x)
        treated.STA{chan_ind}(:,:,:) = treated.STA{chan_ind}(:,:,:) + checkerboard(:,:,trig_ind + IS.Latencies);
        treated.Nspk(chan_ind) = treated.Nspk(chan_ind) + 1;
    end

%fprintf('%d \n',size(n_times))
%fprintf('%d \n',size(n_cells))

if length(chan_ind_l)>1
    arrayfun(@(x,y) one_time_STA(x,y,treated,IS,checkerboard), trig_ind_l, chan_ind_l)
else
    arrayfun(@(x) one_time_STA(x,chan_ind_l,treated,IS,checkerboard), trig_ind_l)
end

end

