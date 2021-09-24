function st_scores = estimateSTscore(psth, xpsth, dt_psth, sust_win, trans_win)


% make sure the sustained and transient window are inside the xpsth boundaries

if sust_win(1) < min(xpsth) || sust_win(2) >  max(xpsth) + dt_psth
    error_struct.message = "the sustained window chosen to estimate cell activation lies outside the response time interval";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if trans_win(1) < min(xpsth) || trans_win(2) >  max(xpsth) + dt_psth
    error_struct.message = "the transient window chosen to estimate cell activation lies outside the response time interval";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


psth_dt_by_cell = psth';
st_scores = zeros(1, size(psth, 1));

for icell=1:size(psth_dt_by_cell,2)
    psth_sustained = psth_dt_by_cell(find(xpsth>= sust_win(1)& xpsth< sust_win(2)), icell);
    psth_transient = psth_dt_by_cell(find(xpsth>= trans_win(1)& xpsth< trans_win(2)), icell);
%     st_scores(icell) = min(1, max(psth_sustained) /  max(psth_transient));
    st_scores(icell) = max(psth_sustained) /  (max(psth_sustained) + max(psth_transient));
end
